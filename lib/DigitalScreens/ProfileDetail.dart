import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:smart_society_new/Admin_App/Component/LoadingComponent.dart';
import 'package:smart_society_new/DigitalCommon/Constants.dart' as cnst;
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:geocoder/geocoder.dart';

import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_society_new/Member_App/common/constant.dart';
import 'package:smart_society_new/DigitalCommon/ClassList.dart';
import 'package:smart_society_new/DigitalCommon/Services.dart';
import 'package:smart_society_new/Member_App/common/Services.dart' as serv;

import 'package:url_launcher/url_launcher.dart';

class ProfileDetail extends StatefulWidget {
  @override
  _ProfileDetailState createState() => _ProfileDetailState();
}

class _ProfileDetailState extends State<ProfileDetail>
    with TickerProviderStateMixin {
  var location = new Location();

  File _imageCover;
  bool _editCoverImg = false;

  File _imageProfile;
  bool _editProfileImg = false;

  ImageListener _listener;
  String MemberId = "";

  bool showProfileEdit = false;
  bool isProfileLoading = true;
  bool showCompanyEdit = false;
  Map<String, dynamic> profileList;

  MemberClass memberdata = new MemberClass();

  TextEditingController txtDate = new TextEditingController();

  TextEditingController txtName = new TextEditingController();
  TextEditingController txtMobile = new TextEditingController();
  TextEditingController txtAbout = new TextEditingController();
  TextEditingController txtEmail = new TextEditingController();
  TextEditingController txtWebsite = new TextEditingController();
  TextEditingController txtWhatsApp = new TextEditingController();
  TextEditingController txtFaceboook = new TextEditingController();
  TextEditingController txtTwitter = new TextEditingController();
  TextEditingController txtGoogle = new TextEditingController();
  TextEditingController txtLinkedin = new TextEditingController();
  TextEditingController txtYoutube = new TextEditingController();
  TextEditingController txtIntagram = new TextEditingController();
  TextEditingController txtImage = new TextEditingController();
  TextEditingController txtCoverImage = new TextEditingController();
  TextEditingController txtPersonalPAN = new TextEditingController();

  TextEditingController txtCompany = new TextEditingController();
  TextEditingController txtRole = new TextEditingController();
  TextEditingController txtCompanyUrl = new TextEditingController();
  TextEditingController txtAddress = new TextEditingController();
  TextEditingController txtPhone = new TextEditingController();
  TextEditingController txtCompanyEmail = new TextEditingController();
  TextEditingController txtMap = new TextEditingController();
  TextEditingController txtAboutCompany = new TextEditingController();
  TextEditingController txtGstNo = new TextEditingController();
  TextEditingController txtCompanyPAN = new TextEditingController();
  TextEditingController txtShareMsg = new TextEditingController();

  DateTime date = new DateTime.now();

  bool editName = false;
  bool editMobile = false;
  bool editEmail = false;
  bool editWeb = false;
  bool editWhatsapp = false;
  bool editPersonalPan = false;
  bool editFacebook = false;
  bool editTwitter = false;
  bool editGoogle = false;
  bool editLinkedin = false;
  bool editYoutube = false;
  bool editInstagram = false;
  bool editAbout = false;
  bool editCompany = false;
  bool editRole = false;
  bool editPhone = false;
  bool editCompanyEmail = false;
  bool editCompanyUrl = false;
  bool editCompanyAddress = false;
  bool editCompanyMap = false;
  bool editCompanyPan = false;
  bool editCompanyGst = false;
  bool editCompanyAbout = false;
  bool editShareMsg = false;

  bool isLoading = false;
  String firstTime;
  ScrollController scrollController;
  String appBarTitle = "";

  @override
  void initState() {
    super.initState();
    // GetProfileData();
    //  _getUpdatedProfile();
    checkFirstTime();
    txtDate.text = date.year.toString() +
        '-' +
        date.month.toString() +
        '-' +
        date.day.toString();
    scrollController = new ScrollController();
    scrollController.addListener(() => setState(() {}));
  }

  checkFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    firstTime = prefs.getString(Session.forFirstTime);
    if (firstTime == "true") {
      GetProfileData();
    } else {
      _getUpdatedProfile();
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  GetProfileData() {
    Services.GetMemberDetail().then((data) {
      setState(() {
        memberdata = data[0];
        isProfileLoading = false;
      });

      SetDataToController1();
    });
  }

  _getUpdatedProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    txtName.text = prefs.getString(Session.Name);
    txtEmail.text = "abc213@gmail.com";
    txtImage.text = "";
    txtMobile.text = prefs.getString(Session.session_login);
    txtCompany.text = prefs.getString(Session.CompanyName);

    try {
      final result = await InternetAddress.lookup('google.com');
      setState(() {
        isProfileLoading = true;
      });

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        setState(() {
          isProfileLoading = false;
        });
        SetDataToController();
        _getDigitalProfileMember();
        // CreateDigital(txtMobile, txtName, txtEmail);

        print("=================================");
      }
    } on SocketException catch (_) {
      Fluttertoast.showToast(msg: "No Internet Connection.");
    }
    // try {
    //   final result = await InternetAddress.lookup('google.com');
    //   if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
    //     SharedPreferences prefs = await SharedPreferences.getInstance();
    //
    //     var body = {
    //       "id": prefs.getString(Session.Member_Id),
    //     };
    //     serv.Services.PostForList(api_name: 'admin/getsingleid', body: body)
    //         .then((ResponseList) async {
    //       setState(() {
    //         isProfileLoading = false;
    //       });
    //       if (ResponseList.length > 0) {
    //         setState(() {
    //           profileList = ResponseList[0];
    //           //set "data" here to your variable
    //         });
    //         SetDataToController();
    //         _getDigitalProfileMember();
    //       } else {
    //         setState(() {
    //           isProfileLoading = false;
    //         });
    //         Fluttertoast.showToast(msg: "Product Not Found");
    //         //show "data not found" in dialog
    //       }
    //     }, onError: (e) {
    //       setState(() {
    //         isProfileLoading = false;
    //       });
    //       print("error on call -> ${e.message}");
    //       Fluttertoast.showToast(msg: "Something Went Wrong");
    //     });
    //   }
    // } on SocketException catch (_) {
    //   Fluttertoast.showToast(msg: "No Internet Connection.");
    // }
  }

  SetDataToController() async {
    //Profile Data
    SharedPreferences prefs = await SharedPreferences.getInstance();
    txtName.text = prefs.getString(Session.Name);
    txtMobile.text = prefs.getString(Session.session_login);
    txtEmail.text = "";
    // txtWebsite.text = "${profileList["name"]}";
    txtWhatsApp.text = prefs.getString(Session.session_login);
    txtFaceboook.text = "";
    txtTwitter.text = "";
    //txtGoogle.text = "${profileList["name"]}";
    txtLinkedin.text = "";
    txtYoutube.text = "";
    txtIntagram.text = "";
    txtAbout.text = "";
    //txtPersonalPAN.text = "${profileList["name"]}";

    //Company Data
    txtCompany.text = prefs.getString(Session.CompanyName);
    // txtRole.text = "${profileList["name"]}";
    txtPhone.text = prefs.getString(Session.session_login);
    txtCompanyEmail.text = "";
    // txtCompanyUrl.text = "${profileList["name"]}";
    txtAddress.text = prefs.getString(Session.Address);
    //txtGstNo.text = "${profileList["name"]}";
    //txtCompanyPAN.text = "${profileList["name"]}";
    txtAboutCompany.text = prefs.getString(Session.BusinessDescription);
    //txtMap.text = "${profileList["name"]}";
    // txtShareMsg.text = "${profileList["name"]}";

    setState(() {
      MemberId = prefs.getString(Session.Member_Id);
    });
  }

  SetDataToController1() {
    //Profile Data
    txtName.text = memberdata.Name;
    txtMobile.text = memberdata.Mobile;
    txtEmail.text = memberdata.Email;
    txtWebsite.text = memberdata.website;
    txtWhatsApp.text = memberdata.Whatsappno;
    txtFaceboook.text = memberdata.Facebooklink;
    txtTwitter.text = memberdata.Twitter;
    txtGoogle.text = memberdata.Google;
    txtLinkedin.text = memberdata.Linkedin;
    txtYoutube.text = memberdata.Youtube;
    txtIntagram.text = memberdata.Instagram;
    txtAbout.text = memberdata.About;
    txtPersonalPAN.text = memberdata.PersonalPAN;

    //Company Data
    txtCompany.text = memberdata.Company;
    txtRole.text = memberdata.Role;
    txtPhone.text = memberdata.CompanyPhone;
    txtCompanyEmail.text = memberdata.CompanyEmail;
    txtCompanyUrl.text = memberdata.CompanyUrl;
    txtAddress.text = memberdata.CompanyAddress;
    txtGstNo.text = memberdata.GstNo;
    txtCompanyPAN.text = memberdata.CompanyPAN;
    txtAboutCompany.text = memberdata.AboutCompany;
    txtMap.text = memberdata.GMap;
    txtShareMsg.text = memberdata.ShareMsg;

    setState(() {
      MemberId = memberdata.Id;
    });
  }

  _getDigitalProfileMember() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String memberId = prefs.getString(Session.digital_Id);

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Services.UpdateDigitalProfileMember(
          txtImage.text,
          txtImage.text,
          txtName.text,
          txtMobile.text,
          txtEmail.text,
          "",
          txtWhatsApp.text,
          "",
          txtFaceboook.text,
          txtTwitter.text,
          "",
          txtLinkedin.text,
          txtYoutube.text,
          txtIntagram.text,
          txtAbout.text,
          txtCompany.text,
          "",
          txtMobile.text,
          "",
          "",
          "",
          txtCompanyEmail.text,
          "",
          txtAddress.text,
          txtAboutCompany.text,
          "",
          memberId,
        ).then((ResponseList) async {
          setState(() {
            isProfileLoading = false;
          });
          Fluttertoast.showToast(msg: "Enter Successfully");
          prefs.setString(Session.forFirstTime, "true");
          //show "data not found" in dialog
        }, onError: (e) {
          setState(() {
            isProfileLoading = false;
          });
          print("error on call -> ${e.message}");
          Fluttertoast.showToast(msg: "Something Went Wrong");
        });
      }
    } on SocketException catch (_) {
      Fluttertoast.showToast(msg: "No Internet Connection.");
    }
  }

  Future<bool> updateProfile(String column, String columndata) async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String memberId = prefs.getString(Session.digital_Id);
    var data = {
      'type': 'profile',
      'column': column.toString(),
      'columndata': columndata.replaceAll("'", "''").toString(),
      'memberid': prefs.getString(Session.digital_Id).toString(),
    };
    print(data);
    Services.UpdateProfile(data).then((data) {
      if (data != null && data.ERROR_STATUS == false) {
        Fluttertoast.showToast(
            msg: "Data Saved",
            backgroundColor: Colors.green,
            gravity: ToastGravity.TOP);
        setState(() {
          isLoading = false;
        });
        return true;
      } else {
        Fluttertoast.showToast(
            msg: "Data Not Saved" + data.MESSAGE,
            backgroundColor: Colors.red,
            gravity: ToastGravity.TOP,
            toastLength: Toast.LENGTH_LONG);
        setState(() {
          isLoading = false;
        });
        return false;
      }
    }, onError: (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(
          msg: "Data Not Saved" + e.toString(), backgroundColor: Colors.red);
      return false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildActions() {
      double scale;
      if (scrollController.hasClients) {
        scale = scrollController.offset / 280;
        scale = scale * 2;
        if (scale > 1) {
          scale = 1.0;
          appBarTitle = "Profile";
        } else {
          appBarTitle = "";
        }
      } else {
        scale = 0.0;
        appBarTitle = "";
      }

      return new Transform(
        transform: new Matrix4.identity()..scale(scale, scale),
        alignment: Alignment.center,
        //child: profile,
      );
    }

    return Scaffold(
      body: isProfileLoading == true
          ? LoadingComponent()
          : firstTime == "true"
              ? WillPopScope(
                  onWillPop: () {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, '/DashBoard1');
                  },
                  child: DefaultTabController(
                    length: 2,
                    child: NestedScrollView(
                      controller: scrollController,
                      headerSliverBuilder:
                          (BuildContext context, bool innerBoxIsScrolled) {
                        return <Widget>[
                          SliverAppBar(
                            expandedHeight: 200.0,
                            floating: false,
                            pinned: true,
                            leading: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.pushReplacementNamed(
                                      context, '/DashBoard1');
                                },
                                child: Icon(Icons.arrow_back)),
                            flexibleSpace: FlexibleSpaceBar(
                              centerTitle: false,
                              title: Text("${appBarTitle}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                  )),
                              background: Stack(
                                children: <Widget>[
                                  _imageCover == null
                                      ? memberdata.CoverImage != null
                                          ? FadeInImage.assetNetwork(
                                              placeholder:
                                                  "images/profilebackground.png",
                                              image: memberdata.CoverImage,
                                              height: 230,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              fit: BoxFit.cover)
                                          : Image.asset(
                                              "images/profilebackground.png",
                                              height: 230,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              fit: BoxFit.cover)
                                      : Image.file(File(_imageCover.path),
                                          height: 230,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          fit: BoxFit.cover),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 0, top: 20),
                                    child: new Center(
                                      child: _imageProfile == null
                                          ? memberdata.Image != null
                                              ? ClipOval(
                                                  child:
                                                      FadeInImage.assetNetwork(
                                                          placeholder:
                                                              "images/users.png",
                                                          image:
                                                              memberdata.Image,
                                                          height: 100,
                                                          width: 100,
                                                          fit: BoxFit.cover),
                                                )
                                              : Container(
                                                  decoration: new BoxDecoration(
                                                      color:
                                                          cnst.appMaterialColor,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  75))),
                                                  width: 100,
                                                  height: 100,
                                                  child: Center(
                                                      child: Text(
                                                          "${memberdata.Name.toString().substring(0, 1)}",
                                                          style: TextStyle(
                                                              decoration:
                                                                  TextDecoration
                                                                      .none,
                                                              fontSize: 30,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500))),
                                                )
                                          : ClipOval(
                                              child: Image.file(
                                                  File(_imageProfile.path),
                                                  height: 100,
                                                  width: 100,
                                                  fit: BoxFit.cover),
                                            ),
                                    ),
                                  ),
                                  Container(
                                      width: MediaQuery.of(context).size.width,
                                      color: Color.fromRGBO(0, 0, 0, 0.4),
                                      margin: EdgeInsets.only(top: 180),
                                      height: 50,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          _editProfileImg
                                              ? Container(
                                                  width: (MediaQuery.of(context)
                                                              .size
                                                              .width -
                                                          30) /
                                                      2,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: <Widget>[
                                                      GestureDetector(
                                                          child: Icon(
                                                              Icons
                                                                  .done_outline,
                                                              color:
                                                                  Colors.white),
                                                          onTap: () async {
                                                            String img = '';

                                                            if (_imageProfile !=
                                                                null) {
                                                              setState(() {
                                                                isLoading =
                                                                    true;
                                                              });
                                                              List<int>
                                                                  imageBytes =
                                                                  await _imageProfile
                                                                      .readAsBytesSync();
                                                              String
                                                                  base64Image =
                                                                  base64Encode(
                                                                      imageBytes);
                                                              img = base64Image;

                                                              updateProfile(
                                                                      'Image',
                                                                      img)
                                                                  .then((val) {
                                                                setState(() {
                                                                  _editProfileImg =
                                                                      false;
                                                                });
                                                              }, onError: (e) {
                                                                setState(() {
                                                                  _editProfileImg =
                                                                      false;
                                                                });
                                                              });
                                                            }
                                                          }),
                                                      GestureDetector(
                                                          child: Icon(
                                                              Icons.close,
                                                              color:
                                                                  Colors.white),
                                                          onTap: () async {
                                                            setState(() {
                                                              _editProfileImg =
                                                                  false;
                                                              _imageProfile =
                                                                  null;
                                                            });
                                                          })
                                                    ],
                                                  ),
                                                )
                                              : MaterialButton(
                                                  onPressed: () {
                                                    _profileImagePopup(context);
                                                  },
                                                  child: Text(
                                                    "Edit Photo",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  minWidth:
                                                      (MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              30) /
                                                          2,
                                                ),
                                          //Divider
                                          Container(
                                            height: 30,
                                            width: 3,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))),
                                          ),
                                          //Divider End
                                          _editCoverImg
                                              ? Container(
                                                  width: (MediaQuery.of(context)
                                                              .size
                                                              .width -
                                                          30) /
                                                      2,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: <Widget>[
                                                      GestureDetector(
                                                          child: Icon(
                                                              Icons
                                                                  .done_outline,
                                                              color:
                                                                  Colors.white),
                                                          onTap: () async {
                                                            String img = '';

                                                            if (_imageCover !=
                                                                null) {
                                                              setState(() {
                                                                isLoading =
                                                                    true;
                                                              });
                                                              List<int>
                                                                  imageBytes =
                                                                  await _imageCover
                                                                      .readAsBytesSync();
                                                              String
                                                                  base64Image =
                                                                  base64Encode(
                                                                      imageBytes);
                                                              img = base64Image;

                                                              updateProfile(
                                                                      'CoverImage',
                                                                      img)
                                                                  .then((val) {
                                                                setState(() {
                                                                  _editCoverImg =
                                                                      false;
                                                                });
                                                              }, onError: (e) {
                                                                setState(() {
                                                                  _editCoverImg =
                                                                      false;
                                                                });
                                                              });
                                                            }
                                                          }),
                                                      GestureDetector(
                                                          child: Icon(
                                                              Icons.close,
                                                              color:
                                                                  Colors.white),
                                                          onTap: () async {
                                                            setState(() {
                                                              _editCoverImg =
                                                                  false;
                                                              _imageCover =
                                                                  null;
                                                            });
                                                          })
                                                    ],
                                                  ),
                                                )
                                              : MaterialButton(
                                                  onPressed: () {
                                                    _coverImagePopup(context);
                                                  },
                                                  child: Text(
                                                    "Edit Cover",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  minWidth:
                                                      (MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              30) /
                                                          2,
                                                )
                                        ],
                                      ))
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              new Padding(
                                padding: EdgeInsets.all(5.0),
                                child: _buildActions(),
                              ),
                            ],
                          ),
                          SliverPersistentHeader(
                            delegate: _SliverAppBarDelegate(
                              TabBar(
                                labelColor: Colors.black87,
                                unselectedLabelColor: Colors.grey,
                                tabs: [
                                  Tab(text: "Personal"),
                                  Tab(text: "Company"),
                                ],
                              ),
                            ),
                            pinned: true,
                          ),
                        ];
                      },
                      body: TabBarView(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              AnimatedContainer(
                                duration: Duration(milliseconds: 500),
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(
                                    top: 10, left: 10, right: 10, bottom: 50),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    border: Border.all(
                                        color: Colors.grey[600], width: 0.5)),
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      /*Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Text("Profile",
                                  style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600)),
                            ),*/
                                      //Name
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 20, top: 10),
                                        child: AnimatedSize(
                                          duration: Duration(milliseconds: 250),
                                          curve: Curves.easeInOut,
                                          vsync: this,
                                          child: !editName
                                              ? Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              80,
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Image.asset(
                                                              "images/user24.png"),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10),
                                                            child: Text(
                                                                memberdata.Name !=
                                                                        null
                                                                    ? memberdata
                                                                        .Name
                                                                    : "",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                            .grey[
                                                                        600],
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600)),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            editName = true;
                                                          });
                                                        },
                                                        child: Icon(Icons.edit))
                                                  ],
                                                )
                                              : Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              150,
                                                      //margin: EdgeInsets.only(top: 20),
                                                      decoration: BoxDecoration(
                                                          color: Color.fromRGBO(
                                                              255,
                                                              255,
                                                              255,
                                                              0.5),
                                                          border:
                                                              new Border.all(
                                                                  width: 1),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                      child: TextFormField(
                                                        controller: txtName,
                                                        decoration: InputDecoration(
                                                            prefixIcon: Image.asset(
                                                                "images/user24.png"),
                                                            hintText: "Name"),
                                                        keyboardType:
                                                            TextInputType.text,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      //height: 40,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 20),
                                                      child: GestureDetector(
                                                          onTap: () {
                                                            if (txtName.text !=
                                                                "") {
                                                              updateProfile(
                                                                      'Name',
                                                                      txtName
                                                                          .text)
                                                                  .then((val) {
                                                                memberdata
                                                                        .Name =
                                                                    txtName
                                                                        .text;
                                                                setState(() {
                                                                  editName =
                                                                      false;
                                                                });
                                                              }, onError: (e) {
                                                                txtName.text =
                                                                    memberdata
                                                                        .Name;
                                                                setState(() {
                                                                  editName =
                                                                      false;
                                                                });
                                                              });
                                                            } else {
                                                              Fluttertoast.showToast(
                                                                  msg:
                                                                      "Please Enter Data First",
                                                                  toastLength: Toast
                                                                      .LENGTH_SHORT,
                                                                  gravity:
                                                                      ToastGravity
                                                                          .TOP,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .yellow,
                                                                  textColor:
                                                                      Colors
                                                                          .black,
                                                                  fontSize:
                                                                      15.0);
                                                            }
                                                          },
                                                          child: Icon(Icons
                                                              .done_outline)),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            txtName.text =
                                                                memberdata.Name;
                                                            editName = false;
                                                          });
                                                        },
                                                        child:
                                                            Icon(Icons.close))
                                                  ],
                                                ),
                                        ),
                                      ),

                                      //Mobile
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: AnimatedSize(
                                          duration: Duration(milliseconds: 250),
                                          curve: Curves.easeInOut,
                                          vsync: this,
                                          child: !editMobile
                                              ? Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              80,
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Image.asset(
                                                              "images/telephone24.png"),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10),
                                                            child: Text(
                                                                memberdata.Mobile !=
                                                                        null
                                                                    ? memberdata
                                                                        .Mobile
                                                                    : "",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                            .grey[
                                                                        600],
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600)),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            editMobile = true;
                                                          });
                                                        },
                                                        child: Icon(Icons.edit))
                                                  ],
                                                )
                                              : Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              150,
                                                      //margin: EdgeInsets.only(top: 20),
                                                      decoration: BoxDecoration(
                                                          color: Color.fromRGBO(
                                                              255,
                                                              255,
                                                              255,
                                                              0.5),
                                                          border:
                                                              new Border.all(
                                                                  width: 1),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                      child: TextFormField(
                                                        controller: txtMobile,
                                                        decoration: InputDecoration(
                                                            prefixIcon: Image.asset(
                                                                "images/telephone24.png"),
                                                            hintText: "Mobile"),
                                                        keyboardType:
                                                            TextInputType.phone,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      //height: 40,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 20),
                                                      child: GestureDetector(
                                                          onTap: () {
                                                            if (txtMobile
                                                                    .text !=
                                                                "") {
                                                              updateProfile(
                                                                      'Mobile',
                                                                      txtMobile
                                                                          .text)
                                                                  .then((val) {
                                                                memberdata
                                                                        .Mobile =
                                                                    txtMobile
                                                                        .text;
                                                                setState(() {
                                                                  editMobile =
                                                                      false;
                                                                });
                                                              }, onError: (e) {
                                                                txtMobile.text =
                                                                    memberdata
                                                                        .Mobile;
                                                                setState(() {
                                                                  editMobile =
                                                                      false;
                                                                });
                                                              });
                                                            } else {
                                                              Fluttertoast.showToast(
                                                                  msg:
                                                                      "Please Enter Data First",
                                                                  toastLength: Toast
                                                                      .LENGTH_SHORT,
                                                                  gravity:
                                                                      ToastGravity
                                                                          .TOP,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .yellow,
                                                                  textColor:
                                                                      Colors
                                                                          .black,
                                                                  fontSize:
                                                                      15.0);
                                                            }
                                                          },
                                                          child: Icon(Icons
                                                              .done_outline)),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            txtMobile.text =
                                                                memberdata
                                                                    .Mobile;
                                                            editMobile = false;
                                                          });
                                                        },
                                                        child:
                                                            Icon(Icons.close))
                                                  ],
                                                ),
                                        ),
                                      ),

                                      //Email
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: AnimatedSize(
                                          duration: Duration(milliseconds: 250),
                                          curve: Curves.easeInOut,
                                          vsync: this,
                                          child: !editEmail
                                              ? Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              80,
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Image.asset(
                                                              "images/gmail24.png"),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10),
                                                            child: Text(
                                                                memberdata.Email !=
                                                                        null
                                                                    ? memberdata
                                                                        .Email
                                                                    : "",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                            .grey[
                                                                        600],
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600)),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            editEmail = true;
                                                          });
                                                        },
                                                        child: Icon(Icons.edit))
                                                  ],
                                                )
                                              : Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              150,
                                                      //margin: EdgeInsets.only(top: 20),
                                                      decoration: BoxDecoration(
                                                          color: Color.fromRGBO(
                                                              255,
                                                              255,
                                                              255,
                                                              0.5),
                                                          border:
                                                              new Border.all(
                                                                  width: 1),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                      child: TextFormField(
                                                        controller: txtEmail,
                                                        decoration: InputDecoration(
                                                            prefixIcon: Image.asset(
                                                                "images/gmail24.png"),
                                                            hintText: "Email"),
                                                        keyboardType:
                                                            TextInputType
                                                                .emailAddress,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      //height: 40,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 20),
                                                      child: GestureDetector(
                                                          onTap: () {
                                                            if (txtEmail.text !=
                                                                "") {
                                                              updateProfile(
                                                                      'Email',
                                                                      txtEmail
                                                                          .text)
                                                                  .then((val) {
                                                                memberdata
                                                                        .Email =
                                                                    txtEmail
                                                                        .text;
                                                                setState(() {
                                                                  editEmail =
                                                                      false;
                                                                });
                                                              }, onError: (e) {
                                                                txtEmail.text =
                                                                    memberdata
                                                                        .Email;
                                                                setState(() {
                                                                  editEmail =
                                                                      false;
                                                                });
                                                              });
                                                            } else {
                                                              Fluttertoast.showToast(
                                                                  msg:
                                                                      "Please Enter Data First",
                                                                  toastLength: Toast
                                                                      .LENGTH_SHORT,
                                                                  gravity:
                                                                      ToastGravity
                                                                          .TOP,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .yellow,
                                                                  textColor:
                                                                      Colors
                                                                          .black,
                                                                  fontSize:
                                                                      15.0);
                                                            }
                                                          },
                                                          child: Icon(Icons
                                                              .done_outline)),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            txtEmail.text =
                                                                memberdata
                                                                    .Email;
                                                            editEmail = false;
                                                          });
                                                        },
                                                        child:
                                                            Icon(Icons.close))
                                                  ],
                                                ),
                                        ),
                                      ),

                                      //Website
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: AnimatedSize(
                                          duration: Duration(milliseconds: 250),
                                          curve: Curves.easeInOut,
                                          vsync: this,
                                          child: !editWeb
                                              ? Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              80,
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Image.asset(
                                                              "images/domain24.png"),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10),
                                                            child: Text(
                                                                memberdata.website !=
                                                                        null
                                                                    ? memberdata
                                                                        .website
                                                                    : "",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                            .grey[
                                                                        600],
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600)),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            editWeb = true;
                                                          });
                                                        },
                                                        child: Icon(Icons.edit))
                                                  ],
                                                )
                                              : Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              150,
                                                      //margin: EdgeInsets.only(top: 20),
                                                      decoration: BoxDecoration(
                                                          color: Color.fromRGBO(
                                                              255,
                                                              255,
                                                              255,
                                                              0.5),
                                                          border:
                                                              new Border.all(
                                                                  width: 1),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                      child: TextFormField(
                                                        controller: txtWebsite,
                                                        decoration: InputDecoration(
                                                            prefixIcon: Image.asset(
                                                                "images/domain24.png"),
                                                            hintText:
                                                                "website"),
                                                        keyboardType:
                                                            TextInputType.url,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      //height: 40,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 20),
                                                      child: GestureDetector(
                                                          onTap: () {
                                                            if (txtWebsite
                                                                    .text !=
                                                                "") {
                                                              updateProfile(
                                                                      'website',
                                                                      txtWebsite
                                                                          .text)
                                                                  .then((val) {
                                                                memberdata
                                                                        .website =
                                                                    txtWebsite
                                                                        .text;
                                                                setState(() {
                                                                  editWeb =
                                                                      false;
                                                                });
                                                              }, onError: (e) {
                                                                txtWebsite
                                                                        .text =
                                                                    memberdata
                                                                        .website;
                                                                setState(() {
                                                                  editWeb =
                                                                      false;
                                                                });
                                                              });
                                                            } else {
                                                              Fluttertoast.showToast(
                                                                  msg:
                                                                      "Please Enter Data First",
                                                                  toastLength: Toast
                                                                      .LENGTH_SHORT,
                                                                  gravity:
                                                                      ToastGravity
                                                                          .TOP,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .yellow,
                                                                  textColor:
                                                                      Colors
                                                                          .black,
                                                                  fontSize:
                                                                      15.0);
                                                            }
                                                          },
                                                          child: Icon(Icons
                                                              .done_outline)),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          txtWebsite.text =
                                                              memberdata
                                                                  .website;
                                                          setState(() {
                                                            editWeb = false;
                                                          });
                                                        },
                                                        child:
                                                            Icon(Icons.close))
                                                  ],
                                                ),
                                        ),
                                      ),

                                      //Whatsapp
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: AnimatedSize(
                                          duration: Duration(milliseconds: 250),
                                          curve: Curves.easeInOut,
                                          vsync: this,
                                          child: !editWhatsapp
                                              ? Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              80,
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Image.asset(
                                                              "images/whatsapp24.png"),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10),
                                                            child: Text(
                                                                memberdata.Whatsappno !=
                                                                        null
                                                                    ? memberdata
                                                                        .Whatsappno
                                                                    : "",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                            .grey[
                                                                        600],
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600)),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            editWhatsapp = true;
                                                          });
                                                        },
                                                        child: Icon(Icons.edit))
                                                  ],
                                                )
                                              : Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              150,
                                                      //margin: EdgeInsets.only(top: 20),
                                                      decoration: BoxDecoration(
                                                          color: Color.fromRGBO(
                                                              255,
                                                              255,
                                                              255,
                                                              0.5),
                                                          border:
                                                              new Border.all(
                                                                  width: 1),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                      child: TextFormField(
                                                        controller: txtWhatsApp,
                                                        decoration: InputDecoration(
                                                            prefixIcon: Image.asset(
                                                                "images/whatsapp24.png"),
                                                            hintText:
                                                                "Whatsapp No"),
                                                        keyboardType:
                                                            TextInputType.phone,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      //height: 40,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 20),
                                                      child: GestureDetector(
                                                          onTap: () {
                                                            if (txtWhatsApp
                                                                    .text !=
                                                                "") {
                                                              updateProfile(
                                                                      'Whatsappno',
                                                                      txtWhatsApp
                                                                          .text)
                                                                  .then((val) {
                                                                memberdata
                                                                        .Whatsappno =
                                                                    txtWhatsApp
                                                                        .text;
                                                                setState(() {
                                                                  editWhatsapp =
                                                                      false;
                                                                });
                                                              }, onError: (e) {
                                                                txtWhatsApp
                                                                        .text =
                                                                    memberdata
                                                                        .Whatsappno;
                                                                setState(() {
                                                                  editWhatsapp =
                                                                      false;
                                                                });
                                                              });
                                                            } else {
                                                              Fluttertoast.showToast(
                                                                  msg:
                                                                      "Please Enter Data First",
                                                                  toastLength: Toast
                                                                      .LENGTH_SHORT,
                                                                  gravity:
                                                                      ToastGravity
                                                                          .TOP,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .yellow,
                                                                  textColor:
                                                                      Colors
                                                                          .black,
                                                                  fontSize:
                                                                      15.0);
                                                            }
                                                          },
                                                          child: Icon(Icons
                                                              .done_outline)),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          txtWhatsApp.text =
                                                              memberdata
                                                                  .Whatsappno;
                                                          setState(() {
                                                            editWhatsapp =
                                                                false;
                                                          });
                                                        },
                                                        child:
                                                            Icon(Icons.close))
                                                  ],
                                                ),
                                        ),
                                      ),

                                      //PAN
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: AnimatedSize(
                                          duration: Duration(milliseconds: 250),
                                          curve: Curves.easeInOut,
                                          vsync: this,
                                          child: !editPersonalPan
                                              ? Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              80,
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Image.asset(
                                                              "images/pan.png"),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10),
                                                            child: Text(
                                                                memberdata.PersonalPAN !=
                                                                        null
                                                                    ? memberdata
                                                                        .PersonalPAN
                                                                    : "",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                            .grey[
                                                                        600],
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600)),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            editPersonalPan =
                                                                true;
                                                          });
                                                        },
                                                        child: Icon(Icons.edit))
                                                  ],
                                                )
                                              : Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              150,
                                                      //margin: EdgeInsets.only(top: 20),
                                                      decoration: BoxDecoration(
                                                          color: Color.fromRGBO(
                                                              255,
                                                              255,
                                                              255,
                                                              0.5),
                                                          border:
                                                              new Border.all(
                                                                  width: 1),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                      child: TextFormField(
                                                        controller:
                                                            txtPersonalPAN,
                                                        decoration: InputDecoration(
                                                            prefixIcon: Image.asset(
                                                                "images/pan.png"),
                                                            hintText: "PAN No"),
                                                        keyboardType:
                                                            TextInputType.text,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      //height: 40,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 20),
                                                      child: GestureDetector(
                                                          onTap: () {
                                                            if (txtPersonalPAN
                                                                    .text !=
                                                                "") {
                                                              updateProfile(
                                                                      'PersonalPAN',
                                                                      txtPersonalPAN
                                                                          .text)
                                                                  .then((val) {
                                                                memberdata
                                                                        .PersonalPAN =
                                                                    txtPersonalPAN
                                                                        .text;
                                                                setState(() {
                                                                  editPersonalPan =
                                                                      false;
                                                                });
                                                              }, onError: (e) {
                                                                txtPersonalPAN
                                                                        .text =
                                                                    memberdata
                                                                        .PersonalPAN;
                                                                setState(() {
                                                                  editPersonalPan =
                                                                      false;
                                                                });
                                                              });
                                                            } else {
                                                              Fluttertoast.showToast(
                                                                  msg:
                                                                      "Please Enter Data First",
                                                                  toastLength: Toast
                                                                      .LENGTH_SHORT,
                                                                  gravity:
                                                                      ToastGravity
                                                                          .TOP,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .yellow,
                                                                  textColor:
                                                                      Colors
                                                                          .black,
                                                                  fontSize:
                                                                      15.0);
                                                            }
                                                          },
                                                          child: Icon(Icons
                                                              .done_outline)),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          txtPersonalPAN.text =
                                                              memberdata
                                                                  .PersonalPAN;
                                                          setState(() {
                                                            editPersonalPan =
                                                                false;
                                                          });
                                                        },
                                                        child:
                                                            Icon(Icons.close))
                                                  ],
                                                ),
                                        ),
                                      ),

                                      //Facebook
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: AnimatedSize(
                                          duration: Duration(milliseconds: 250),
                                          curve: Curves.easeInOut,
                                          vsync: this,
                                          child: !editFacebook
                                              ? Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              80,
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Image.asset(
                                                              "images/facebook24.png"),
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                110,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 10),
                                                              child: Text(
                                                                  memberdata.Facebooklink !=
                                                                          null
                                                                      ? memberdata
                                                                          .Facebooklink
                                                                      : "",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                              .grey[
                                                                          600],
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600)),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            editFacebook = true;
                                                          });
                                                        },
                                                        child: Icon(Icons.edit))
                                                  ],
                                                )
                                              : Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              150,
                                                      //margin: EdgeInsets.only(top: 20),
                                                      decoration: BoxDecoration(
                                                          color: Color.fromRGBO(
                                                              255,
                                                              255,
                                                              255,
                                                              0.5),
                                                          border:
                                                              new Border.all(
                                                                  width: 1),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                      child: TextFormField(
                                                        controller:
                                                            txtFaceboook,
                                                        decoration: InputDecoration(
                                                            prefixIcon: Image.asset(
                                                                "images/facebook24.png"),
                                                            hintText:
                                                                "Facebook Page"),
                                                        keyboardType:
                                                            TextInputType.url,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      //height: 40,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 20),
                                                      child: GestureDetector(
                                                          onTap: () {
                                                            if (txtFaceboook
                                                                    .text !=
                                                                "") {
                                                              updateProfile(
                                                                      'Facebooklink',
                                                                      txtFaceboook
                                                                          .text)
                                                                  .then((val) {
                                                                memberdata
                                                                        .Facebooklink =
                                                                    txtFaceboook
                                                                        .text;
                                                                setState(() {
                                                                  editFacebook =
                                                                      false;
                                                                });
                                                              }, onError: (e) {
                                                                txtFaceboook
                                                                        .text =
                                                                    memberdata
                                                                        .Facebooklink;
                                                                setState(() {
                                                                  editFacebook =
                                                                      false;
                                                                });
                                                              });
                                                            } else {
                                                              Fluttertoast.showToast(
                                                                  msg:
                                                                      "Please Enter Data First",
                                                                  toastLength: Toast
                                                                      .LENGTH_SHORT,
                                                                  gravity:
                                                                      ToastGravity
                                                                          .TOP,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .yellow,
                                                                  textColor:
                                                                      Colors
                                                                          .black,
                                                                  fontSize:
                                                                      15.0);
                                                            }
                                                          },
                                                          child: Icon(Icons
                                                              .done_outline)),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          txtFaceboook.text =
                                                              memberdata
                                                                  .Facebooklink;
                                                          setState(() {
                                                            editFacebook =
                                                                false;
                                                          });
                                                        },
                                                        child:
                                                            Icon(Icons.close))
                                                  ],
                                                ),
                                        ),
                                      ),

                                      //Twitter
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: AnimatedSize(
                                          duration: Duration(milliseconds: 250),
                                          curve: Curves.easeInOut,
                                          vsync: this,
                                          child: !editTwitter
                                              ? Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              80,
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Image.asset(
                                                              "images/twitter24.png"),
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                110,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 10),
                                                              child: Text(
                                                                  memberdata.Twitter !=
                                                                          null
                                                                      ? memberdata
                                                                          .Twitter
                                                                      : "",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                              .grey[
                                                                          600],
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600)),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            editTwitter = true;
                                                          });
                                                        },
                                                        child: Icon(Icons.edit))
                                                  ],
                                                )
                                              : Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              150,
                                                      //margin: EdgeInsets.only(top: 20),
                                                      decoration: BoxDecoration(
                                                          color: Color.fromRGBO(
                                                              255,
                                                              255,
                                                              255,
                                                              0.5),
                                                          border:
                                                              new Border.all(
                                                                  width: 1),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                      child: TextFormField(
                                                        controller: txtTwitter,
                                                        decoration: InputDecoration(
                                                            prefixIcon: Image.asset(
                                                                "images/twitter24.png"),
                                                            hintText:
                                                                "Twitter Page"),
                                                        keyboardType:
                                                            TextInputType.url,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      //height: 40,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 20),
                                                      child: GestureDetector(
                                                          onTap: () {
                                                            if (txtTwitter
                                                                    .text !=
                                                                "") {
                                                              updateProfile(
                                                                      'Twitter',
                                                                      txtTwitter
                                                                          .text)
                                                                  .then((val) {
                                                                memberdata
                                                                        .Twitter =
                                                                    txtTwitter
                                                                        .text;
                                                                setState(() {
                                                                  editTwitter =
                                                                      false;
                                                                });
                                                              }, onError: (e) {
                                                                txtTwitter
                                                                        .text =
                                                                    memberdata
                                                                        .Twitter;
                                                                setState(() {
                                                                  editTwitter =
                                                                      false;
                                                                });
                                                              });
                                                            } else {
                                                              Fluttertoast.showToast(
                                                                  msg:
                                                                      "Please Enter Data First",
                                                                  toastLength: Toast
                                                                      .LENGTH_SHORT,
                                                                  gravity:
                                                                      ToastGravity
                                                                          .TOP,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .yellow,
                                                                  textColor:
                                                                      Colors
                                                                          .black,
                                                                  fontSize:
                                                                      15.0);
                                                            }
                                                          },
                                                          child: Icon(Icons
                                                              .done_outline)),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          txtTwitter.text =
                                                              memberdata
                                                                  .Twitter;
                                                          setState(() {
                                                            editTwitter = false;
                                                          });
                                                        },
                                                        child:
                                                            Icon(Icons.close))
                                                  ],
                                                ),
                                        ),
                                      ),

                                      //Google
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: AnimatedSize(
                                          duration: Duration(milliseconds: 250),
                                          curve: Curves.easeInOut,
                                          vsync: this,
                                          child: !editGoogle
                                              ? Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              80,
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Image.asset(
                                                              "images/googleplus24.png"),
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                110,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 10),
                                                              child: Text(
                                                                  memberdata.Google !=
                                                                          null
                                                                      ? memberdata
                                                                          .Google
                                                                      : "",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                              .grey[
                                                                          600],
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600)),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            editGoogle = true;
                                                          });
                                                        },
                                                        child: Icon(Icons.edit))
                                                  ],
                                                )
                                              : Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              150,
                                                      //margin: EdgeInsets.only(top: 20),
                                                      decoration: BoxDecoration(
                                                          color: Color.fromRGBO(
                                                              255,
                                                              255,
                                                              255,
                                                              0.5),
                                                          border:
                                                              new Border.all(
                                                                  width: 1),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                      child: TextFormField(
                                                        controller: txtGoogle,
                                                        decoration: InputDecoration(
                                                            prefixIcon: Image.asset(
                                                                "images/googleplus24.png"),
                                                            hintText:
                                                                "Google Page"),
                                                        keyboardType:
                                                            TextInputType.url,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      //height: 40,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 20),
                                                      child: GestureDetector(
                                                          onTap: () {
                                                            if (txtGoogle
                                                                    .text !=
                                                                "") {
                                                              updateProfile(
                                                                      'Google',
                                                                      txtGoogle
                                                                          .text)
                                                                  .then((val) {
                                                                memberdata
                                                                        .Google =
                                                                    txtGoogle
                                                                        .text;
                                                                setState(() {
                                                                  editGoogle =
                                                                      false;
                                                                });
                                                              }, onError: (e) {
                                                                txtGoogle.text =
                                                                    memberdata
                                                                        .Google;
                                                                setState(() {
                                                                  editGoogle =
                                                                      false;
                                                                });
                                                              });
                                                            } else {
                                                              Fluttertoast.showToast(
                                                                  msg:
                                                                      "Please Enter Data First",
                                                                  toastLength: Toast
                                                                      .LENGTH_SHORT,
                                                                  gravity:
                                                                      ToastGravity
                                                                          .TOP,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .yellow,
                                                                  textColor:
                                                                      Colors
                                                                          .black,
                                                                  fontSize:
                                                                      15.0);
                                                            }
                                                          },
                                                          child: Icon(Icons
                                                              .done_outline)),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          txtGoogle.text =
                                                              memberdata.Google;
                                                          setState(() {
                                                            editGoogle = false;
                                                          });
                                                        },
                                                        child:
                                                            Icon(Icons.close))
                                                  ],
                                                ),
                                        ),
                                      ),

                                      //Linkedin
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: AnimatedSize(
                                          duration: Duration(milliseconds: 250),
                                          curve: Curves.easeInOut,
                                          vsync: this,
                                          child: !editLinkedin
                                              ? Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              80,
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Image.asset(
                                                              "images/linkedin24.png"),
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                110,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 10),
                                                              child: Text(
                                                                  memberdata.Linkedin !=
                                                                          null
                                                                      ? memberdata
                                                                          .Linkedin
                                                                      : "",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                              .grey[
                                                                          600],
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600)),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            editLinkedin = true;
                                                          });
                                                        },
                                                        child: Icon(Icons.edit))
                                                  ],
                                                )
                                              : Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              150,
                                                      //margin: EdgeInsets.only(top: 20),
                                                      decoration: BoxDecoration(
                                                          color: Color.fromRGBO(
                                                              255,
                                                              255,
                                                              255,
                                                              0.5),
                                                          border:
                                                              new Border.all(
                                                                  width: 1),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                      child: TextFormField(
                                                        controller: txtLinkedin,
                                                        decoration: InputDecoration(
                                                            prefixIcon: Image.asset(
                                                                "images/linkedin24.png"),
                                                            hintText:
                                                                "Linkedin Page"),
                                                        keyboardType:
                                                            TextInputType.url,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      //height: 40,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 20),
                                                      child: GestureDetector(
                                                          onTap: () {
                                                            if (txtLinkedin
                                                                    .text !=
                                                                "") {
                                                              updateProfile(
                                                                      'Linkedin',
                                                                      txtLinkedin
                                                                          .text)
                                                                  .then((val) {
                                                                memberdata
                                                                        .Linkedin =
                                                                    txtLinkedin
                                                                        .text;
                                                                setState(() {
                                                                  editLinkedin =
                                                                      false;
                                                                });
                                                              }, onError: (e) {
                                                                txtLinkedin
                                                                        .text =
                                                                    memberdata
                                                                        .Linkedin;
                                                                setState(() {
                                                                  editLinkedin =
                                                                      false;
                                                                });
                                                              });
                                                            } else {
                                                              Fluttertoast.showToast(
                                                                  msg:
                                                                      "Please Enter Data First",
                                                                  toastLength: Toast
                                                                      .LENGTH_SHORT,
                                                                  gravity:
                                                                      ToastGravity
                                                                          .TOP,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .yellow,
                                                                  textColor:
                                                                      Colors
                                                                          .black,
                                                                  fontSize:
                                                                      15.0);
                                                            }
                                                          },
                                                          child: Icon(Icons
                                                              .done_outline)),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          txtLinkedin.text =
                                                              memberdata
                                                                  .Linkedin;
                                                          setState(() {
                                                            editLinkedin =
                                                                false;
                                                          });
                                                        },
                                                        child:
                                                            Icon(Icons.close))
                                                  ],
                                                ),
                                        ),
                                      ),

                                      //Youtube
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: AnimatedSize(
                                          duration: Duration(milliseconds: 250),
                                          curve: Curves.easeInOut,
                                          vsync: this,
                                          child: !editYoutube
                                              ? Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              80,
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Image.asset(
                                                              "images/youtube24.png"),
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                110,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 10),
                                                              child: Text(
                                                                  memberdata.Youtube !=
                                                                          null
                                                                      ? memberdata
                                                                          .Youtube
                                                                      : "",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                              .grey[
                                                                          600],
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600)),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            editYoutube = true;
                                                          });
                                                        },
                                                        child: Icon(Icons.edit))
                                                  ],
                                                )
                                              : Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              150,
                                                      //margin: EdgeInsets.only(top: 20),
                                                      decoration: BoxDecoration(
                                                          color: Color.fromRGBO(
                                                              255,
                                                              255,
                                                              255,
                                                              0.5),
                                                          border:
                                                              new Border.all(
                                                                  width: 1),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                      child: TextFormField(
                                                        controller: txtYoutube,
                                                        decoration: InputDecoration(
                                                            prefixIcon: Image.asset(
                                                                "images/youtube24.png"),
                                                            hintText:
                                                                "Youtube Page"),
                                                        keyboardType:
                                                            TextInputType.url,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      //height: 40,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 20),
                                                      child: GestureDetector(
                                                          onTap: () {
                                                            if (txtYoutube
                                                                    .text !=
                                                                "") {
                                                              updateProfile(
                                                                      'Youtube',
                                                                      txtYoutube
                                                                          .text)
                                                                  .then((val) {
                                                                memberdata
                                                                        .Youtube =
                                                                    txtYoutube
                                                                        .text;
                                                                setState(() {
                                                                  editYoutube =
                                                                      false;
                                                                });
                                                              }, onError: (e) {
                                                                txtYoutube
                                                                        .text =
                                                                    memberdata
                                                                        .Youtube;
                                                                setState(() {
                                                                  editYoutube =
                                                                      false;
                                                                });
                                                              });
                                                            } else {
                                                              Fluttertoast.showToast(
                                                                  msg:
                                                                      "Please Enter Data First",
                                                                  toastLength: Toast
                                                                      .LENGTH_SHORT,
                                                                  gravity:
                                                                      ToastGravity
                                                                          .TOP,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .yellow,
                                                                  textColor:
                                                                      Colors
                                                                          .black,
                                                                  fontSize:
                                                                      15.0);
                                                            }
                                                            setState(() {
                                                              editYoutube =
                                                                  false;
                                                            });
                                                          },
                                                          child: Icon(Icons
                                                              .done_outline)),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          txtYoutube.text =
                                                              memberdata
                                                                  .Youtube;
                                                          setState(() {
                                                            editYoutube = false;
                                                          });
                                                        },
                                                        child:
                                                            Icon(Icons.close))
                                                  ],
                                                ),
                                        ),
                                      ),

                                      //Instagram
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: AnimatedSize(
                                          duration: Duration(milliseconds: 250),
                                          curve: Curves.easeInOut,
                                          vsync: this,
                                          child: !editInstagram
                                              ? Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              80,
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Image.asset(
                                                              "images/instagram24.png"),
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                110,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 10),
                                                              child: Text(
                                                                  memberdata.Instagram !=
                                                                          null
                                                                      ? memberdata
                                                                          .Instagram
                                                                      : "",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                              .grey[
                                                                          600],
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600)),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            editInstagram =
                                                                true;
                                                          });
                                                        },
                                                        child: Icon(Icons.edit))
                                                  ],
                                                )
                                              : Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              150,
                                                      //margin: EdgeInsets.only(top: 20),
                                                      decoration: BoxDecoration(
                                                          color: Color.fromRGBO(
                                                              255,
                                                              255,
                                                              255,
                                                              0.5),
                                                          border:
                                                              new Border.all(
                                                                  width: 1),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                      child: TextFormField(
                                                        controller: txtIntagram,
                                                        decoration: InputDecoration(
                                                            prefixIcon: Image.asset(
                                                                "images/instagram24.png"),
                                                            hintText:
                                                                "Instagram Page"),
                                                        keyboardType:
                                                            TextInputType.url,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      //height: 40,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 20),
                                                      child: GestureDetector(
                                                          onTap: () {
                                                            if (txtIntagram
                                                                    .text !=
                                                                "") {
                                                              updateProfile(
                                                                      'Instagram',
                                                                      txtIntagram
                                                                          .text)
                                                                  .then((val) {
                                                                memberdata
                                                                        .Instagram =
                                                                    txtIntagram
                                                                        .text;
                                                                setState(() {
                                                                  editInstagram =
                                                                      false;
                                                                });
                                                              }, onError: (e) {
                                                                txtIntagram
                                                                        .text =
                                                                    memberdata
                                                                        .Instagram;
                                                                setState(() {
                                                                  editInstagram =
                                                                      false;
                                                                });
                                                              });
                                                            } else {
                                                              Fluttertoast.showToast(
                                                                  msg:
                                                                      "Please Enter Data First",
                                                                  toastLength: Toast
                                                                      .LENGTH_SHORT,
                                                                  gravity:
                                                                      ToastGravity
                                                                          .TOP,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .yellow,
                                                                  textColor:
                                                                      Colors
                                                                          .black,
                                                                  fontSize:
                                                                      15.0);
                                                            }
                                                          },
                                                          child: Icon(Icons
                                                              .done_outline)),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          txtIntagram.text =
                                                              memberdata
                                                                  .Instagram;
                                                          setState(() {
                                                            editInstagram =
                                                                false;
                                                          });
                                                        },
                                                        child:
                                                            Icon(Icons.close))
                                                  ],
                                                ),
                                        ),
                                      ),

                                      //About
                                      AnimatedSize(
                                        duration: Duration(milliseconds: 250),
                                        curve: Curves.easeInOut,
                                        vsync: this,
                                        child: !editAbout
                                            ? Row(
                                                children: <Widget>[
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            80,
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Image.asset(
                                                            "images/negotiation24.png"),
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10),
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width -
                                                              110,
                                                          child: Text(
                                                              memberdata.About !=
                                                                      null
                                                                  ? memberdata
                                                                      .About
                                                                  : "",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                          .grey[
                                                                      600],
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          editAbout = true;
                                                        });
                                                      },
                                                      child: Icon(Icons.edit))
                                                ],
                                              )
                                            : Row(
                                                children: <Widget>[
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            150,
                                                    //margin: EdgeInsets.only(top: 20),
                                                    decoration: BoxDecoration(
                                                        color: Color.fromRGBO(
                                                            255, 255, 255, 0.5),
                                                        border: new Border.all(
                                                            width: 1),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5))),
                                                    child: TextFormField(
                                                      controller: txtAbout,
                                                      maxLines: 3,
                                                      decoration: InputDecoration(
                                                          prefixIcon: Image.asset(
                                                              "images/negotiation24.png"),
                                                          hintText: "About"),
                                                      keyboardType:
                                                          TextInputType.text,
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                    //height: 40,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 20),
                                                    child: GestureDetector(
                                                        onTap: () {
                                                          if (txtAbout.text !=
                                                              "") {
                                                            updateProfile(
                                                                    'About',
                                                                    txtAbout
                                                                        .text)
                                                                .then((val) {
                                                              memberdata.About =
                                                                  txtAbout.text;
                                                              setState(() {
                                                                editAbout =
                                                                    false;
                                                              });
                                                            }, onError: (e) {
                                                              txtAbout.text =
                                                                  memberdata
                                                                      .About;
                                                              setState(() {
                                                                editAbout =
                                                                    false;
                                                              });
                                                            });
                                                          } else {
                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    "Please Enter Data First",
                                                                toastLength: Toast
                                                                    .LENGTH_SHORT,
                                                                gravity:
                                                                    ToastGravity
                                                                        .TOP,
                                                                backgroundColor:
                                                                    Colors
                                                                        .yellow,
                                                                textColor:
                                                                    Colors
                                                                        .black,
                                                                fontSize: 15.0);
                                                          }
                                                        },
                                                        child: Icon(Icons
                                                            .done_outline)),
                                                  ),
                                                  GestureDetector(
                                                      onTap: () {
                                                        txtAbout.text =
                                                            memberdata.About;
                                                        setState(() {
                                                          editAbout = false;
                                                        });
                                                      },
                                                      child: Icon(Icons.close))
                                                ],
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.only(top: 10),
                                  height: 48,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(0))),
                                  child: MaterialButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(0.0)),
                                    color: cnst.appMaterialColor,
                                    minWidth: MediaQuery.of(context).size.width,
                                    onPressed: () {
                                      showEventDialog(context);
                                    },
                                    child: Text(
                                      "Upload Brochure",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Stack(
                            children: <Widget>[
                              AnimatedContainer(
                                duration: Duration(milliseconds: 500),
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(
                                    top: 10, left: 10, right: 10, bottom: 50),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    border: Border.all(
                                        color: Colors.grey[600], width: 0.5)),
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      /*Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Text("Company",
                                    style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600))),*/

                                      //Company
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 20, top: 10),
                                        child: AnimatedSize(
                                          duration: Duration(milliseconds: 250),
                                          curve: Curves.easeInOut,
                                          vsync: this,
                                          child: !editCompany
                                              ? Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              80,
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Image.asset(
                                                              "images/office24.png"),
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10),
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                110,
                                                            child: Text(
                                                                memberdata.Company !=
                                                                        null
                                                                    ? memberdata
                                                                        .Company
                                                                    : "",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                            .grey[
                                                                        600],
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600)),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            editCompany = true;
                                                          });
                                                        },
                                                        child: Icon(Icons.edit))
                                                  ],
                                                )
                                              : Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              150,
                                                      //margin: EdgeInsets.only(top: 20),
                                                      decoration: BoxDecoration(
                                                          color: Color.fromRGBO(
                                                              255,
                                                              255,
                                                              255,
                                                              0.5),
                                                          border:
                                                              new Border.all(
                                                                  width: 1),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                      child: TextFormField(
                                                        controller: txtCompany,
                                                        decoration: InputDecoration(
                                                            prefixIcon: Image.asset(
                                                                "images/office24.png"),
                                                            hintText:
                                                                "Company Name"),
                                                        keyboardType:
                                                            TextInputType.text,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      //height: 40,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 20),
                                                      child: GestureDetector(
                                                          onTap: () {
                                                            if (txtCompany
                                                                    .text !=
                                                                "") {
                                                              updateProfile(
                                                                      'Company',
                                                                      txtCompany
                                                                          .text)
                                                                  .then((val) {
                                                                memberdata
                                                                        .Company =
                                                                    txtCompany
                                                                        .text;
                                                                setState(() {
                                                                  editCompany =
                                                                      false;
                                                                });
                                                              }, onError: (e) {
                                                                txtCompany
                                                                        .text =
                                                                    memberdata
                                                                        .Company;
                                                                setState(() {
                                                                  editCompany =
                                                                      false;
                                                                });
                                                              });
                                                            } else {
                                                              Fluttertoast.showToast(
                                                                  msg:
                                                                      "Please Enter Data First",
                                                                  toastLength: Toast
                                                                      .LENGTH_SHORT,
                                                                  gravity:
                                                                      ToastGravity
                                                                          .TOP,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .yellow,
                                                                  textColor:
                                                                      Colors
                                                                          .black,
                                                                  fontSize:
                                                                      15.0);
                                                            }
                                                          },
                                                          child: Icon(Icons
                                                              .done_outline)),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          txtCompany.text =
                                                              memberdata
                                                                  .Company;
                                                          setState(() {
                                                            editCompany = false;
                                                          });
                                                        },
                                                        child:
                                                            Icon(Icons.close))
                                                  ],
                                                ),
                                        ),
                                      ),

                                      //Role
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: AnimatedSize(
                                          duration: Duration(milliseconds: 250),
                                          curve: Curves.easeInOut,
                                          vsync: this,
                                          child: !editRole
                                              ? Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              80,
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Image.asset(
                                                              "images/role24.png"),
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10),
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                110,
                                                            child: Text(
                                                                memberdata.Role !=
                                                                        null
                                                                    ? memberdata
                                                                        .Role
                                                                    : "",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                            .grey[
                                                                        600],
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600)),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            editRole = true;
                                                          });
                                                        },
                                                        child: Icon(Icons.edit))
                                                  ],
                                                )
                                              : Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              150,
                                                      //margin: EdgeInsets.only(top: 20),
                                                      decoration: BoxDecoration(
                                                          color: Color.fromRGBO(
                                                              255,
                                                              255,
                                                              255,
                                                              0.5),
                                                          border:
                                                              new Border.all(
                                                                  width: 1),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                      child: TextFormField(
                                                        controller: txtRole,
                                                        decoration: InputDecoration(
                                                            prefixIcon: Image.asset(
                                                                "images/role24.png"),
                                                            hintText: "Role"),
                                                        keyboardType:
                                                            TextInputType.text,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      //height: 40,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 20),
                                                      child: GestureDetector(
                                                          onTap: () {
                                                            if (txtRole.text !=
                                                                "") {
                                                              updateProfile(
                                                                      'Role',
                                                                      txtRole
                                                                          .text)
                                                                  .then((val) {
                                                                memberdata
                                                                        .Role =
                                                                    txtRole
                                                                        .text;
                                                                setState(() {
                                                                  editRole =
                                                                      false;
                                                                });
                                                              }, onError: (e) {
                                                                txtRole.text =
                                                                    memberdata
                                                                        .Role;
                                                                setState(() {
                                                                  editRole =
                                                                      false;
                                                                });
                                                              });
                                                            } else {
                                                              Fluttertoast.showToast(
                                                                  msg:
                                                                      "Please Enter Data First",
                                                                  toastLength: Toast
                                                                      .LENGTH_SHORT,
                                                                  gravity:
                                                                      ToastGravity
                                                                          .TOP,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .yellow,
                                                                  textColor:
                                                                      Colors
                                                                          .black,
                                                                  fontSize:
                                                                      15.0);
                                                            }
                                                          },
                                                          child: Icon(Icons
                                                              .done_outline)),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          txtRole.text =
                                                              memberdata.Role;
                                                          setState(() {
                                                            editRole = false;
                                                          });
                                                        },
                                                        child:
                                                            Icon(Icons.close))
                                                  ],
                                                ),
                                        ),
                                      ),

                                      //Phone
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: AnimatedSize(
                                          duration: Duration(milliseconds: 250),
                                          curve: Curves.easeInOut,
                                          vsync: this,
                                          child: !editPhone
                                              ? Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              80,
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Image.asset(
                                                              "images/telephoneold24.png"),
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10),
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                110,
                                                            child: Text(
                                                                memberdata.CompanyPhone !=
                                                                        null
                                                                    ? memberdata
                                                                        .CompanyPhone
                                                                    : "",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                            .grey[
                                                                        600],
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600)),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            editPhone = true;
                                                          });
                                                        },
                                                        child: Icon(Icons.edit))
                                                  ],
                                                )
                                              : Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              150,
                                                      //margin: EdgeInsets.only(top: 20),
                                                      decoration: BoxDecoration(
                                                          color: Color.fromRGBO(
                                                              255,
                                                              255,
                                                              255,
                                                              0.5),
                                                          border:
                                                              new Border.all(
                                                                  width: 1),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                      child: TextFormField(
                                                        controller: txtPhone,
                                                        decoration: InputDecoration(
                                                            prefixIcon: Image.asset(
                                                                "images/telephoneold24.png"),
                                                            hintText: "Phone"),
                                                        keyboardType:
                                                            TextInputType.phone,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      //height: 40,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 20),
                                                      child: GestureDetector(
                                                          onTap: () {
                                                            if (txtPhone.text !=
                                                                "") {
                                                              updateProfile(
                                                                      'CompanyPhone',
                                                                      txtPhone
                                                                          .text)
                                                                  .then((val) {
                                                                memberdata
                                                                        .CompanyPhone =
                                                                    txtPhone
                                                                        .text;
                                                                setState(() {
                                                                  editPhone =
                                                                      false;
                                                                });
                                                              }, onError: (e) {
                                                                txtPhone.text =
                                                                    memberdata
                                                                        .CompanyPhone;
                                                                setState(() {
                                                                  editPhone =
                                                                      false;
                                                                });
                                                              });
                                                            } else {
                                                              Fluttertoast.showToast(
                                                                  msg:
                                                                      "Please Enter Data First",
                                                                  toastLength: Toast
                                                                      .LENGTH_SHORT,
                                                                  gravity:
                                                                      ToastGravity
                                                                          .TOP,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .yellow,
                                                                  textColor:
                                                                      Colors
                                                                          .black,
                                                                  fontSize:
                                                                      15.0);
                                                            }
                                                          },
                                                          child: Icon(Icons
                                                              .done_outline)),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          txtPhone.text =
                                                              memberdata
                                                                  .CompanyPhone;
                                                          setState(() {
                                                            editPhone = false;
                                                          });
                                                        },
                                                        child:
                                                            Icon(Icons.close))
                                                  ],
                                                ),
                                        ),
                                      ),

                                      //PAN
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: AnimatedSize(
                                          duration: Duration(milliseconds: 250),
                                          curve: Curves.easeInOut,
                                          vsync: this,
                                          child: !editCompanyPan
                                              ? Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              80,
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Image.asset(
                                                              "images/pan.png"),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10),
                                                            child: Text(
                                                                memberdata.CompanyPAN !=
                                                                        null
                                                                    ? memberdata
                                                                        .CompanyPAN
                                                                    : "",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                            .grey[
                                                                        600],
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600)),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            editCompanyPan =
                                                                true;
                                                          });
                                                        },
                                                        child: Icon(Icons.edit))
                                                  ],
                                                )
                                              : Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              150,
                                                      //margin: EdgeInsets.only(top: 20),
                                                      decoration: BoxDecoration(
                                                          color: Color.fromRGBO(
                                                              255,
                                                              255,
                                                              255,
                                                              0.5),
                                                          border:
                                                              new Border.all(
                                                                  width: 1),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                      child: TextFormField(
                                                        controller:
                                                            txtCompanyPAN,
                                                        decoration: InputDecoration(
                                                            prefixIcon: Image.asset(
                                                                "images/pan.png"),
                                                            hintText: "PAN No"),
                                                        keyboardType:
                                                            TextInputType.text,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      //height: 40,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 20),
                                                      child: GestureDetector(
                                                          onTap: () {
                                                            if (txtCompanyPAN
                                                                    .text !=
                                                                "") {
                                                              updateProfile(
                                                                      'CompanyPAN',
                                                                      txtCompanyPAN
                                                                          .text)
                                                                  .then((val) {
                                                                memberdata
                                                                        .CompanyPAN =
                                                                    txtCompanyPAN
                                                                        .text;
                                                                setState(() {
                                                                  editCompanyPan =
                                                                      false;
                                                                });
                                                              }, onError: (e) {
                                                                txtCompanyPAN
                                                                        .text =
                                                                    memberdata
                                                                        .CompanyPAN;
                                                                setState(() {
                                                                  editCompanyPan =
                                                                      false;
                                                                });
                                                              });
                                                            } else {
                                                              Fluttertoast.showToast(
                                                                  msg:
                                                                      "Please Enter Data First",
                                                                  toastLength: Toast
                                                                      .LENGTH_SHORT,
                                                                  gravity:
                                                                      ToastGravity
                                                                          .TOP,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .yellow,
                                                                  textColor:
                                                                      Colors
                                                                          .black,
                                                                  fontSize:
                                                                      15.0);
                                                            }
                                                          },
                                                          child: Icon(Icons
                                                              .done_outline)),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          txtCompanyPAN.text =
                                                              memberdata
                                                                  .CompanyPAN;
                                                          setState(() {
                                                            editCompanyPan =
                                                                false;
                                                          });
                                                        },
                                                        child:
                                                            Icon(Icons.close))
                                                  ],
                                                ),
                                        ),
                                      ),

                                      //GST
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: AnimatedSize(
                                          duration: Duration(milliseconds: 250),
                                          curve: Curves.easeInOut,
                                          vsync: this,
                                          child: !editCompanyGst
                                              ? Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              80,
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Image.asset(
                                                              "images/gst.png",
                                                              height: 24,
                                                              width: 24),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10),
                                                            child: Text(
                                                                memberdata.GstNo !=
                                                                        null
                                                                    ? memberdata
                                                                        .GstNo
                                                                    : "",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                            .grey[
                                                                        600],
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600)),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            editCompanyGst =
                                                                true;
                                                          });
                                                        },
                                                        child: Icon(Icons.edit))
                                                  ],
                                                )
                                              : Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              150,
                                                      //margin: EdgeInsets.only(top: 20),
                                                      decoration: BoxDecoration(
                                                          color: Color.fromRGBO(
                                                              255,
                                                              255,
                                                              255,
                                                              0.5),
                                                          border:
                                                              new Border.all(
                                                                  width: 1),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                      child: TextFormField(
                                                        controller: txtGstNo,
                                                        decoration: InputDecoration(
                                                            prefixIcon: Image.asset(
                                                                "images/gst.png",
                                                                height: 10,
                                                                width: 10),
                                                            hintText: "GST No"),
                                                        keyboardType:
                                                            TextInputType.text,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      //height: 40,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 20),
                                                      child: GestureDetector(
                                                          onTap: () {
                                                            if (txtGstNo.text !=
                                                                "") {
                                                              updateProfile(
                                                                      'GstNo',
                                                                      txtGstNo
                                                                          .text)
                                                                  .then((val) {
                                                                memberdata
                                                                        .GstNo =
                                                                    txtGstNo
                                                                        .text;
                                                                setState(() {
                                                                  editCompanyGst =
                                                                      false;
                                                                });
                                                              }, onError: (e) {
                                                                txtGstNo.text =
                                                                    memberdata
                                                                        .GstNo;
                                                                setState(() {
                                                                  editCompanyGst =
                                                                      false;
                                                                });
                                                              });
                                                            } else {
                                                              Fluttertoast.showToast(
                                                                  msg:
                                                                      "Please Enter Data First",
                                                                  toastLength: Toast
                                                                      .LENGTH_SHORT,
                                                                  gravity:
                                                                      ToastGravity
                                                                          .TOP,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .yellow,
                                                                  textColor:
                                                                      Colors
                                                                          .black,
                                                                  fontSize:
                                                                      15.0);
                                                            }
                                                          },
                                                          child: Icon(Icons
                                                              .done_outline)),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          txtGstNo.text =
                                                              memberdata.GstNo;
                                                          setState(() {
                                                            editCompanyGst =
                                                                false;
                                                          });
                                                        },
                                                        child:
                                                            Icon(Icons.close))
                                                  ],
                                                ),
                                        ),
                                      ),

                                      //MAP
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: AnimatedSize(
                                          duration: Duration(milliseconds: 250),
                                          curve: Curves.easeInOut,
                                          vsync: this,
                                          child: !editCompanyMap
                                              ? Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              80,
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Image.asset(
                                                              "images/mapRoute24.png",
                                                              height: 24,
                                                              width: 24),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10),
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                String url =
                                                                    'google.navigation:q=${txtMap.text}';
                                                                print(
                                                                    'Map Url : $url');
                                                                launch(url);
                                                              },
                                                              child: Text(
                                                                  memberdata.GMap !=
                                                                          null
                                                                      ? memberdata
                                                                          .GMap
                                                                      : "",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .blue,
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600)),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            editCompanyMap =
                                                                true;
                                                          });
                                                        },
                                                        child: Icon(Icons.edit))
                                                  ],
                                                )
                                              : Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              180,
                                                      //margin: EdgeInsets.only(top: 20),
                                                      decoration: BoxDecoration(
                                                          color: Color.fromRGBO(
                                                              255,
                                                              255,
                                                              255,
                                                              0.5),
                                                          border:
                                                              new Border.all(
                                                                  width: 1),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                      child: TextFormField(
                                                        controller: txtMap,
                                                        maxLines: 2,
                                                        decoration: InputDecoration(
                                                            prefixIcon: Image.asset(
                                                                "images/mapRoute24.png",
                                                                height: 24,
                                                                width: 24),
                                                            hintText:
                                                                "Map Location"),
                                                        keyboardType:
                                                            TextInputType.text,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      //height: 40,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 15),
                                                      child: GestureDetector(
                                                          onTap: () async {
                                                            setState(() {
                                                              isLoading = true;
                                                            });
                                                            try {
                                                              location
                                                                  .getLocation()
                                                                  .then((val) {
                                                                if (val !=
                                                                    null) {
                                                                  txtMap
                                                                      .text = val
                                                                          .latitude
                                                                          .toString() +
                                                                      ',' +
                                                                      val.longitude
                                                                          .toString();
                                                                }
                                                                setState(() {
                                                                  isLoading =
                                                                      false;
                                                                });
                                                              });
                                                            } on PlatformException catch (e) {
                                                              if (e.code ==
                                                                  'PERMISSION_DENIED') {
                                                                print(
                                                                    'Permission denied');
                                                              }
                                                              setState(() {
                                                                isLoading =
                                                                    false;
                                                              });
                                                            }
                                                          },
                                                          child: Image.asset(
                                                              "images/google24.png")),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 20),
                                                      child: GestureDetector(
                                                          onTap: () {
                                                            if (txtMap.text !=
                                                                "") {
                                                              updateProfile(
                                                                      'Map',
                                                                      txtMap
                                                                          .text)
                                                                  .then((val) {
                                                                memberdata
                                                                        .GMap =
                                                                    txtMap.text;
                                                                setState(() {
                                                                  editCompanyMap =
                                                                      false;
                                                                });
                                                              }, onError: (e) {
                                                                txtMap.text =
                                                                    memberdata
                                                                        .GMap;
                                                                setState(() {
                                                                  editCompanyMap =
                                                                      false;
                                                                });
                                                              });
                                                            } else {
                                                              Fluttertoast.showToast(
                                                                  msg:
                                                                      "Please Enter Data First",
                                                                  toastLength: Toast
                                                                      .LENGTH_SHORT,
                                                                  gravity:
                                                                      ToastGravity
                                                                          .TOP,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .yellow,
                                                                  textColor:
                                                                      Colors
                                                                          .black,
                                                                  fontSize:
                                                                      15.0);
                                                            }
                                                          },
                                                          child: Icon(Icons
                                                              .done_outline)),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          txtMap.text =
                                                              memberdata.GMap;
                                                          setState(() {
                                                            editCompanyMap =
                                                                false;
                                                          });
                                                        },
                                                        child:
                                                            Icon(Icons.close))
                                                  ],
                                                ),
                                        ),
                                      ),

                                      //Company Email
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: AnimatedSize(
                                          duration: Duration(milliseconds: 250),
                                          curve: Curves.easeInOut,
                                          vsync: this,
                                          child: !editCompanyEmail
                                              ? Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              80,
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Image.asset(
                                                              "images/gmail24.png"),
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10),
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                110,
                                                            child: Text(
                                                                memberdata.CompanyEmail !=
                                                                        null
                                                                    ? memberdata
                                                                        .CompanyEmail
                                                                    : "",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                            .grey[
                                                                        600],
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600)),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            editCompanyEmail =
                                                                true;
                                                          });
                                                        },
                                                        child: Icon(Icons.edit))
                                                  ],
                                                )
                                              : Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              150,
                                                      //margin: EdgeInsets.only(top: 20),
                                                      decoration: BoxDecoration(
                                                          color: Color.fromRGBO(
                                                              255,
                                                              255,
                                                              255,
                                                              0.5),
                                                          border:
                                                              new Border.all(
                                                                  width: 1),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                      child: TextFormField(
                                                        controller:
                                                            txtCompanyEmail,
                                                        decoration: InputDecoration(
                                                            prefixIcon: Image.asset(
                                                                "images/gmail24.png"),
                                                            hintText: "mail"),
                                                        keyboardType:
                                                            TextInputType
                                                                .emailAddress,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      //height: 40,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 20),
                                                      child: GestureDetector(
                                                          onTap: () {
                                                            if (txtCompanyEmail
                                                                    .text !=
                                                                "") {
                                                              updateProfile(
                                                                      'CompanyEmail',
                                                                      txtCompanyEmail
                                                                          .text)
                                                                  .then((val) {
                                                                memberdata
                                                                        .CompanyEmail =
                                                                    txtCompanyEmail
                                                                        .text;
                                                                setState(() {
                                                                  editCompanyEmail =
                                                                      false;
                                                                });
                                                              }, onError: (e) {
                                                                txtCompanyEmail
                                                                        .text =
                                                                    memberdata
                                                                        .CompanyEmail;
                                                                setState(() {
                                                                  editCompanyEmail =
                                                                      false;
                                                                });
                                                              });
                                                            } else {
                                                              Fluttertoast.showToast(
                                                                  msg:
                                                                      "Please Enter Data First",
                                                                  toastLength: Toast
                                                                      .LENGTH_SHORT,
                                                                  gravity:
                                                                      ToastGravity
                                                                          .TOP,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .yellow,
                                                                  textColor:
                                                                      Colors
                                                                          .black,
                                                                  fontSize:
                                                                      15.0);
                                                            }
                                                          },
                                                          child: Icon(Icons
                                                              .done_outline)),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          txtCompanyEmail.text =
                                                              memberdata
                                                                  .CompanyEmail;
                                                          setState(() {
                                                            editCompanyEmail =
                                                                false;
                                                          });
                                                        },
                                                        child:
                                                            Icon(Icons.close))
                                                  ],
                                                ),
                                        ),
                                      ),

                                      //Company Website
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: AnimatedSize(
                                          duration: Duration(milliseconds: 250),
                                          curve: Curves.easeInOut,
                                          vsync: this,
                                          child: !editCompanyUrl
                                              ? Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              80,
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Image.asset(
                                                              "images/domain24.png"),
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10),
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                110,
                                                            child: Text(
                                                                memberdata.CompanyUrl !=
                                                                        null
                                                                    ? memberdata
                                                                        .CompanyUrl
                                                                    : "",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                            .grey[
                                                                        600],
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600)),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            editCompanyUrl =
                                                                true;
                                                          });
                                                        },
                                                        child: Icon(Icons.edit))
                                                  ],
                                                )
                                              : Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              150,
                                                      //margin: EdgeInsets.only(top: 20),
                                                      decoration: BoxDecoration(
                                                          color: Color.fromRGBO(
                                                              255,
                                                              255,
                                                              255,
                                                              0.5),
                                                          border:
                                                              new Border.all(
                                                                  width: 1),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                      child: TextFormField(
                                                        controller:
                                                            txtCompanyUrl,
                                                        decoration: InputDecoration(
                                                            prefixIcon: Image.asset(
                                                                "images/domain24.png"),
                                                            hintText:
                                                                "Website"),
                                                        keyboardType:
                                                            TextInputType.url,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      //height: 40,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 20),
                                                      child: GestureDetector(
                                                          onTap: () {
                                                            if (txtCompanyUrl
                                                                    .text !=
                                                                "") {
                                                              updateProfile(
                                                                      'CompanyUrl',
                                                                      txtCompanyUrl
                                                                          .text)
                                                                  .then((val) {
                                                                memberdata
                                                                        .CompanyUrl =
                                                                    txtCompanyUrl
                                                                        .text;
                                                                setState(() {
                                                                  editCompanyUrl =
                                                                      false;
                                                                });
                                                              }, onError: (e) {
                                                                txtCompanyUrl
                                                                        .text =
                                                                    memberdata
                                                                        .CompanyUrl;
                                                                setState(() {
                                                                  editCompanyUrl =
                                                                      false;
                                                                });
                                                              });
                                                            } else {
                                                              Fluttertoast.showToast(
                                                                  msg:
                                                                      "Please Enter Data First",
                                                                  toastLength: Toast
                                                                      .LENGTH_SHORT,
                                                                  gravity:
                                                                      ToastGravity
                                                                          .TOP,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .yellow,
                                                                  textColor:
                                                                      Colors
                                                                          .black,
                                                                  fontSize:
                                                                      15.0);
                                                            }
                                                          },
                                                          child: Icon(Icons
                                                              .done_outline)),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          txtCompanyUrl.text =
                                                              memberdata
                                                                  .CompanyUrl;
                                                          setState(() {
                                                            editCompanyUrl =
                                                                false;
                                                          });
                                                        },
                                                        child:
                                                            Icon(Icons.close))
                                                  ],
                                                ),
                                        ),
                                      ),

                                      //Comapny Address
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: AnimatedSize(
                                          duration: Duration(milliseconds: 250),
                                          curve: Curves.easeInOut,
                                          vsync: this,
                                          child: !editCompanyAddress
                                              ? Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              80,
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Image.asset(
                                                              "images/google24.png"),
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10),
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                110,
                                                            child: Text(
                                                                memberdata.CompanyAddress !=
                                                                        null
                                                                    ? memberdata
                                                                        .CompanyAddress
                                                                    : "",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                            .grey[
                                                                        600],
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600)),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            editCompanyAddress =
                                                                true;
                                                          });
                                                        },
                                                        child: Icon(Icons.edit))
                                                  ],
                                                )
                                              : Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              180,
                                                      //margin: EdgeInsets.only(top: 20),
                                                      decoration: BoxDecoration(
                                                          color: Color.fromRGBO(
                                                              255,
                                                              255,
                                                              255,
                                                              0.5),
                                                          border:
                                                              new Border.all(
                                                                  width: 1),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                      child: TextFormField(
                                                        maxLines: 5,
                                                        controller: txtAddress,
                                                        decoration: InputDecoration(
                                                            prefixIcon: Image.asset(
                                                                "images/google24.png"),
                                                            hintText:
                                                                "Address"),
                                                        keyboardType:
                                                            TextInputType.text,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      //height: 40,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 15),
                                                      child: GestureDetector(
                                                          onTap: () {
                                                            try {
                                                              setState(() {
                                                                isLoading =
                                                                    true;
                                                              });
                                                              location
                                                                  .getLocation()
                                                                  .then((val) {
                                                                if (val !=
                                                                    null) {
                                                                  final coordinates =
                                                                      new Coordinates(
                                                                          val.latitude,
                                                                          val.longitude);
                                                                  Geocoder.local
                                                                      .findAddressesFromCoordinates(
                                                                          coordinates)
                                                                      .then(
                                                                          (addresses) {
                                                                    if (addresses !=
                                                                        null) {
                                                                      var first =
                                                                          addresses
                                                                              .first;
                                                                      print(
                                                                          "Address : ${first.featureName} : ${first.addressLine}");
                                                                      txtAddress.text = first
                                                                          .addressLine
                                                                          .toString();
                                                                    }
                                                                    setState(
                                                                        () {
                                                                      isLoading =
                                                                          false;
                                                                    });
                                                                  });
                                                                }
                                                              });
                                                            } on PlatformException catch (e) {
                                                              if (e.code ==
                                                                  'PERMISSION_DENIED') {
                                                                print(
                                                                    'Permission denied');
                                                              }
                                                              setState(() {
                                                                isLoading =
                                                                    false;
                                                              });
                                                            }
                                                          },
                                                          child: Image.asset(
                                                              "images/google24.png")),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 20),
                                                      child: GestureDetector(
                                                          onTap: () {
                                                            if (txtAddress
                                                                    .text !=
                                                                "") {
                                                              updateProfile(
                                                                      'CompanyAddress',
                                                                      txtAddress
                                                                          .text)
                                                                  .then((val) {
                                                                memberdata
                                                                        .CompanyAddress =
                                                                    txtAddress
                                                                        .text;
                                                                setState(() {
                                                                  editCompanyAddress =
                                                                      false;
                                                                });
                                                              }, onError: (e) {
                                                                txtAddress
                                                                        .text =
                                                                    memberdata
                                                                        .CompanyAddress;
                                                                setState(() {
                                                                  editCompanyAddress =
                                                                      false;
                                                                });
                                                              });
                                                            } else {
                                                              Fluttertoast.showToast(
                                                                  msg:
                                                                      "Please Enter Data First",
                                                                  toastLength: Toast
                                                                      .LENGTH_SHORT,
                                                                  gravity:
                                                                      ToastGravity
                                                                          .TOP,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .yellow,
                                                                  textColor:
                                                                      Colors
                                                                          .black,
                                                                  fontSize:
                                                                      15.0);
                                                            }
                                                          },
                                                          child: Icon(Icons
                                                              .done_outline)),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          txtAddress.text =
                                                              memberdata
                                                                  .CompanyAddress;
                                                          setState(() {
                                                            editCompanyAddress =
                                                                false;
                                                          });
                                                        },
                                                        child:
                                                            Icon(Icons.close))
                                                  ],
                                                ),
                                        ),
                                      ),

                                      //About
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: AnimatedSize(
                                          duration: Duration(milliseconds: 250),
                                          curve: Curves.easeInOut,
                                          vsync: this,
                                          child: !editCompanyAbout
                                              ? Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              80,
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Image.asset(
                                                              "images/negotiation24.png"),
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10),
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                110,
                                                            child: Text(
                                                                memberdata.AboutCompany !=
                                                                        null
                                                                    ? memberdata
                                                                        .AboutCompany
                                                                    : "",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                            .grey[
                                                                        600],
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600)),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            editCompanyAbout =
                                                                true;
                                                          });
                                                        },
                                                        child: Icon(Icons.edit))
                                                  ],
                                                )
                                              : Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              150,
                                                      //margin: EdgeInsets.only(top: 20),
                                                      decoration: BoxDecoration(
                                                          color: Color.fromRGBO(
                                                              255,
                                                              255,
                                                              255,
                                                              0.5),
                                                          border:
                                                              new Border.all(
                                                                  width: 1),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                      child: TextFormField(
                                                        controller:
                                                            txtAboutCompany,
                                                        maxLines: 3,
                                                        decoration: InputDecoration(
                                                            prefixIcon: Image.asset(
                                                                "images/negotiation24.png"),
                                                            hintText:
                                                                "About Company"),
                                                        keyboardType:
                                                            TextInputType.text,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      //height: 40,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 20),
                                                      child: GestureDetector(
                                                          onTap: () {
                                                            if (txtAboutCompany
                                                                    .text !=
                                                                "") {
                                                              updateProfile(
                                                                      'AboutCompany',
                                                                      txtAboutCompany
                                                                          .text)
                                                                  .then((val) {
                                                                memberdata
                                                                        .AboutCompany =
                                                                    txtAboutCompany
                                                                        .text;
                                                                setState(() {
                                                                  editCompanyAbout =
                                                                      false;
                                                                });
                                                              }, onError: (e) {
                                                                txtAboutCompany
                                                                        .text =
                                                                    memberdata
                                                                        .AboutCompany;
                                                                setState(() {
                                                                  editCompanyAbout =
                                                                      false;
                                                                });
                                                              });
                                                            } else {
                                                              Fluttertoast.showToast(
                                                                  msg:
                                                                      "Please Enter Data First",
                                                                  toastLength: Toast
                                                                      .LENGTH_SHORT,
                                                                  gravity:
                                                                      ToastGravity
                                                                          .TOP,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .yellow,
                                                                  textColor:
                                                                      Colors
                                                                          .black,
                                                                  fontSize:
                                                                      15.0);
                                                            }
                                                          },
                                                          child: Icon(Icons
                                                              .done_outline)),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          txtAboutCompany.text =
                                                              memberdata
                                                                  .AboutCompany;
                                                          setState(() {
                                                            editCompanyAbout =
                                                                false;
                                                          });
                                                        },
                                                        child:
                                                            Icon(Icons.close))
                                                  ],
                                                ),
                                        ),
                                      ),

                                      //Share Msg
                                      AnimatedSize(
                                        duration: Duration(milliseconds: 250),
                                        curve: Curves.easeInOut,
                                        vsync: this,
                                        child: !editShareMsg
                                            ? Row(
                                                children: <Widget>[
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            80,
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Image.asset(
                                                            "images/sharemsg24.png"),
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10),
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width -
                                                              110,
                                                          child: Text(
                                                              memberdata.ShareMsg !=
                                                                      null
                                                                  ? memberdata
                                                                      .ShareMsg
                                                                  : "",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                          .grey[
                                                                      600],
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          editShareMsg = true;
                                                        });
                                                      },
                                                      child: Icon(Icons.edit))
                                                ],
                                              )
                                            : Row(
                                                children: <Widget>[
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            150,
                                                    //margin: EdgeInsets.only(top: 20),
                                                    decoration: BoxDecoration(
                                                        color: Color.fromRGBO(
                                                            255, 255, 255, 0.5),
                                                        border: new Border.all(
                                                            width: 1),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5))),
                                                    child: TextFormField(
                                                      controller: txtShareMsg,
                                                      maxLines: 3,
                                                      decoration: InputDecoration(
                                                          prefixIcon: Image.asset(
                                                              "images/sharemsg24.png"),
                                                          hintText:
                                                              "Share Msg"),
                                                      keyboardType:
                                                          TextInputType.text,
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                    //height: 40,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 20),
                                                    child: GestureDetector(
                                                        onTap: () {
                                                          if (txtShareMsg
                                                                  .text !=
                                                              "") {
                                                            updateProfile(
                                                                    'ShareMsg',
                                                                    txtShareMsg
                                                                        .text)
                                                                .then((val) {
                                                              memberdata
                                                                      .ShareMsg =
                                                                  txtShareMsg
                                                                      .text;
                                                              setState(() {
                                                                editShareMsg =
                                                                    false;
                                                              });
                                                            }, onError: (e) {
                                                              txtShareMsg.text =
                                                                  memberdata
                                                                      .ShareMsg;
                                                              setState(() {
                                                                editShareMsg =
                                                                    false;
                                                              });
                                                            });
                                                          } else {
                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    "Please Enter Data First",
                                                                toastLength: Toast
                                                                    .LENGTH_SHORT,
                                                                gravity:
                                                                    ToastGravity
                                                                        .TOP,
                                                                backgroundColor:
                                                                    Colors
                                                                        .yellow,
                                                                textColor:
                                                                    Colors
                                                                        .black,
                                                                fontSize: 15.0);
                                                          }
                                                        },
                                                        child: Icon(Icons
                                                            .done_outline)),
                                                  ),
                                                  GestureDetector(
                                                      onTap: () {
                                                        txtShareMsg.text =
                                                            memberdata.ShareMsg;
                                                        setState(() {
                                                          editShareMsg = false;
                                                        });
                                                      },
                                                      child: Icon(Icons.close))
                                                ],
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.only(top: 10),
                                  height: 48,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(0))),
                                  child: MaterialButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(0.0)),
                                    color: cnst.appMaterialColor,
                                    minWidth: MediaQuery.of(context).size.width,
                                    onPressed: () {
                                      showEventDialog(context);
                                    },
                                    child: Text(
                                      "Upload Brochure",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : WillPopScope(
                  onWillPop: () {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, '/DashBoard1');
                  },
                  child: DefaultTabController(
                    length: 2,
                    child: NestedScrollView(
                      controller: scrollController,
                      headerSliverBuilder:
                          (BuildContext context, bool innerBoxIsScrolled) {
                        return <Widget>[
                          SliverAppBar(
                            expandedHeight: 200.0,
                            floating: false,
                            pinned: true,
                            leading: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.pushReplacementNamed(
                                      context, '/DashBoard1');
                                },
                                child: Icon(Icons.arrow_back)),
                            flexibleSpace: FlexibleSpaceBar(
                              centerTitle: false,
                              title: Text("${appBarTitle}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                  )),
                              background: Stack(
                                children: <Widget>[
                                  // _imageCover == null
                                  //     ? memberdata.CoverImage != null
                                  txtImage != ""
                                      ? FadeInImage.assetNetwork(
                                          placeholder:
                                              "images/profilebackground.png",
                                          //image: memberdata.CoverImage,
                                          image: txtImage.text,
                                          height: 230,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          fit: BoxFit.cover)
                                      // : Image.asset("images/profilebackground.png",
                                      //     height: 230,
                                      //     width: MediaQuery.of(context).size.width,
                                      //     fit: BoxFit.cover)
                                      // : Image.file(File(_imageCover.path),
                                      : Image.file(File(_imageCover.path),
                                          height: 230,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          fit: BoxFit.cover),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 0, top: 20),
                                    child: new Center(
                                      child: _imageProfile == null
                                          //               ? memberdata.Image != null
                                          ? txtImage.text != "" ||
                                                  txtImage.text != null
                                              ? ClipOval(
                                                  child:
                                                      FadeInImage.assetNetwork(
                                                          placeholder:
                                                              "images/users.png",
                                                          // image: memberdata.Image,
                                                          image: txtImage.text,
                                                          height: 100,
                                                          width: 100,
                                                          fit: BoxFit.cover),
                                                )
                                              : Container(
                                                  decoration: new BoxDecoration(
                                                      color:
                                                          cnst.appMaterialColor,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  75))),
                                                  width: 100,
                                                  height: 100,
                                                  child: Center(
                                                      child: Text(
                                                          "${txtName.toString().substring(0, 1)}",
                                                          style: TextStyle(
                                                              decoration:
                                                                  TextDecoration
                                                                      .none,
                                                              fontSize: 30,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500))),
                                                )
                                          : ClipOval(
                                              child: Image.file(
                                                  File(_imageProfile.path),
                                                  height: 100,
                                                  width: 100,
                                                  fit: BoxFit.cover),
                                            ),
                                    ),
                                  ),
                                  Container(
                                      width: MediaQuery.of(context).size.width,
                                      color: Color.fromRGBO(0, 0, 0, 0.4),
                                      margin: EdgeInsets.only(top: 180),
                                      height: 50,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          _editProfileImg
                                              ? Container(
                                                  width: (MediaQuery.of(context)
                                                              .size
                                                              .width -
                                                          30) /
                                                      2,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: <Widget>[
                                                      GestureDetector(
                                                          child: Icon(
                                                              Icons
                                                                  .done_outline,
                                                              color:
                                                                  Colors.white),
                                                          onTap: () async {
                                                            String img = '';

                                                            if (_imageProfile !=
                                                                null) {
                                                              setState(() {
                                                                isLoading =
                                                                    true;
                                                              });
                                                              List<int>
                                                                  imageBytes =
                                                                  await _imageProfile
                                                                      .readAsBytesSync();
                                                              String
                                                                  base64Image =
                                                                  base64Encode(
                                                                      imageBytes);
                                                              img = base64Image;

                                                              updateProfile(
                                                                      'Image',
                                                                      img)
                                                                  .then((val) {
                                                                setState(() {
                                                                  _editProfileImg =
                                                                      false;
                                                                });
                                                              }, onError: (e) {
                                                                setState(() {
                                                                  _editProfileImg =
                                                                      false;
                                                                });
                                                              });
                                                            }
                                                          }),
                                                      GestureDetector(
                                                          child: Icon(
                                                              Icons.close,
                                                              color:
                                                                  Colors.white),
                                                          onTap: () async {
                                                            setState(() {
                                                              _editProfileImg =
                                                                  false;
                                                              _imageProfile =
                                                                  null;
                                                            });
                                                          })
                                                    ],
                                                  ),
                                                )
                                              : MaterialButton(
                                                  onPressed: () {
                                                    _profileImagePopup(context);
                                                  },
                                                  child: Text(
                                                    "Edit Photo",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  minWidth:
                                                      (MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              30) /
                                                          2,
                                                ),
                                          //Divider
                                          Container(
                                            height: 30,
                                            width: 3,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))),
                                          ),
                                          //Divider End
                                          _editCoverImg
                                              ? Container(
                                                  width: (MediaQuery.of(context)
                                                              .size
                                                              .width -
                                                          30) /
                                                      2,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: <Widget>[
                                                      GestureDetector(
                                                          child: Icon(
                                                              Icons
                                                                  .done_outline,
                                                              color:
                                                                  Colors.white),
                                                          onTap: () async {
                                                            String img = '';

                                                            if (_imageCover !=
                                                                null) {
                                                              setState(() {
                                                                isLoading =
                                                                    true;
                                                              });
                                                              List<int>
                                                                  imageBytes =
                                                                  await _imageCover
                                                                      .readAsBytesSync();
                                                              String
                                                                  base64Image =
                                                                  base64Encode(
                                                                      imageBytes);
                                                              img = base64Image;

                                                              updateProfile(
                                                                      'CoverImage',
                                                                      img)
                                                                  .then((val) {
                                                                setState(() {
                                                                  _editCoverImg =
                                                                      false;
                                                                });
                                                              }, onError: (e) {
                                                                setState(() {
                                                                  _editCoverImg =
                                                                      false;
                                                                });
                                                              });
                                                            }
                                                          }),
                                                      GestureDetector(
                                                          child: Icon(
                                                              Icons.close,
                                                              color:
                                                                  Colors.white),
                                                          onTap: () async {
                                                            setState(() {
                                                              _editCoverImg =
                                                                  false;
                                                              _imageCover =
                                                                  null;
                                                            });
                                                          })
                                                    ],
                                                  ),
                                                )
                                              : MaterialButton(
                                                  onPressed: () {
                                                    _coverImagePopup(context);
                                                  },
                                                  child: Text(
                                                    "Edit Cover",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  minWidth:
                                                      (MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              30) /
                                                          2,
                                                )
                                        ],
                                      ))
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              new Padding(
                                padding: EdgeInsets.all(5.0),
                                child: _buildActions(),
                              ),
                            ],
                          ),
                          SliverPersistentHeader(
                            delegate: _SliverAppBarDelegate(
                              TabBar(
                                labelColor: Colors.black87,
                                unselectedLabelColor: Colors.grey,
                                tabs: [
                                  Tab(text: "Personal"),
                                  Tab(text: "Company"),
                                ],
                              ),
                            ),
                            pinned: true,
                          ),
                        ];
                      },
                      body: TabBarView(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              AnimatedContainer(
                                duration: Duration(milliseconds: 500),
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(
                                    top: 10, left: 10, right: 10, bottom: 50),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    border: Border.all(
                                        color: Colors.grey[600], width: 0.5)),
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      /*Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Text("Profile",
                                  style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600)),
                            ),*/
                                      //Name
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 20, top: 10),
                                        child: AnimatedSize(
                                          duration: Duration(milliseconds: 250),
                                          curve: Curves.easeInOut,
                                          vsync: this,
                                          child: !editName
                                              ? Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              80,
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Image.asset(
                                                              "images/user24.png"),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10),
                                                            child: Text(
                                                                txtName.text !=
                                                                        ""
                                                                    ? txtName
                                                                        .text
                                                                    : "",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                            .grey[
                                                                        600],
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600)),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            editName = true;
                                                          });
                                                        },
                                                        child: Icon(Icons.edit))
                                                  ],
                                                )
                                              : Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              150,
                                                      //margin: EdgeInsets.only(top: 20),
                                                      decoration: BoxDecoration(
                                                          color: Color.fromRGBO(
                                                              255,
                                                              255,
                                                              255,
                                                              0.5),
                                                          border:
                                                              new Border.all(
                                                                  width: 1),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                      child: TextFormField(
                                                        controller: txtName,
                                                        decoration: InputDecoration(
                                                            prefixIcon: Image.asset(
                                                                "images/user24.png"),
                                                            hintText: "Name"),
                                                        keyboardType:
                                                            TextInputType.text,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      //height: 40,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 20),
                                                      child: GestureDetector(
                                                          onTap: () {
                                                            if (txtName.text !=
                                                                "") {
                                                              updateProfile(
                                                                      'Name',
                                                                      txtName
                                                                          .text)
                                                                  .then((val) {
                                                                setState(() {
                                                                  txtName.text =
                                                                      txtName
                                                                          .text;
                                                                  editName =
                                                                      false;
                                                                });
                                                              }, onError: (e) {
                                                                setState(() {
                                                                  txtName.text;
                                                                  editName =
                                                                      false;
                                                                });
                                                              });
                                                            } else {
                                                              Fluttertoast.showToast(
                                                                  msg:
                                                                      "Please Enter Data First",
                                                                  toastLength: Toast
                                                                      .LENGTH_SHORT,
                                                                  gravity:
                                                                      ToastGravity
                                                                          .TOP,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .yellow,
                                                                  textColor:
                                                                      Colors
                                                                          .black,
                                                                  fontSize:
                                                                      15.0);
                                                            }
                                                          },
                                                          child: Icon(Icons
                                                              .done_outline)),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            txtName.text =
                                                                txtName.text;
                                                            editName = false;
                                                          });
                                                        },
                                                        child:
                                                            Icon(Icons.close))
                                                  ],
                                                ),
                                        ),
                                      ),

                                      //Mobile
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: AnimatedSize(
                                          duration: Duration(milliseconds: 250),
                                          curve: Curves.easeInOut,
                                          vsync: this,
                                          child: !editMobile
                                              ? Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              80,
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Image.asset(
                                                              "images/telephone24.png"),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10),
                                                            child: Text(
                                                                txtMobile.text !=
                                                                        ""
                                                                    ? profileList[
                                                                        "mobile"]
                                                                    : "",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                            .grey[
                                                                        600],
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600)),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            editMobile = true;
                                                          });
                                                        },
                                                        child: Icon(Icons.edit))
                                                  ],
                                                )
                                              : Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              150,
                                                      //margin: EdgeInsets.only(top: 20),
                                                      decoration: BoxDecoration(
                                                          color: Color.fromRGBO(
                                                              255,
                                                              255,
                                                              255,
                                                              0.5),
                                                          border:
                                                              new Border.all(
                                                                  width: 1),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                      child: TextFormField(
                                                        controller: txtMobile,
                                                        decoration: InputDecoration(
                                                            prefixIcon: Image.asset(
                                                                "images/telephone24.png"),
                                                            hintText: "Mobile"),
                                                        keyboardType:
                                                            TextInputType.phone,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      //height: 40,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 20),
                                                      child: GestureDetector(
                                                          onTap: () {
                                                            if (txtMobile
                                                                    .text !=
                                                                "") {
                                                              updateProfile(
                                                                      'Mobile',
                                                                      txtMobile
                                                                          .text)
                                                                  .then((val) {
                                                                setState(() {
                                                                  profileList[
                                                                          "mobile"] =
                                                                      txtMobile
                                                                          .text;
                                                                  editMobile =
                                                                      false;
                                                                });
                                                              }, onError: (e) {
                                                                setState(() {
                                                                  txtMobile
                                                                          .text =
                                                                      profileList[
                                                                          "mobile"];
                                                                  editMobile =
                                                                      false;
                                                                });
                                                              });
                                                            } else {
                                                              Fluttertoast.showToast(
                                                                  msg:
                                                                      "Please Enter Data First",
                                                                  toastLength: Toast
                                                                      .LENGTH_SHORT,
                                                                  gravity:
                                                                      ToastGravity
                                                                          .TOP,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .yellow,
                                                                  textColor:
                                                                      Colors
                                                                          .black,
                                                                  fontSize:
                                                                      15.0);
                                                            }
                                                          },
                                                          child: Icon(Icons
                                                              .done_outline)),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            txtMobile.text =
                                                                profileList[
                                                                    "mobile"];
                                                            editMobile = false;
                                                          });
                                                        },
                                                        child:
                                                            Icon(Icons.close))
                                                  ],
                                                ),
                                        ),
                                      ),

                                      //Email
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: AnimatedSize(
                                          duration: Duration(milliseconds: 250),
                                          curve: Curves.easeInOut,
                                          vsync: this,
                                          child: !editEmail
                                              ? Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              80,
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Image.asset(
                                                              "images/gmail24.png"),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10),
                                                            child: Text(
                                                                profileList["email"] !=
                                                                        ""
                                                                    ? profileList[
                                                                        "email"]
                                                                    : "",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                            .grey[
                                                                        600],
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600)),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            editEmail = true;
                                                          });
                                                        },
                                                        child: Icon(Icons.edit))
                                                  ],
                                                )
                                              : Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              150,
                                                      //margin: EdgeInsets.only(top: 20),
                                                      decoration: BoxDecoration(
                                                          color: Color.fromRGBO(
                                                              255,
                                                              255,
                                                              255,
                                                              0.5),
                                                          border:
                                                              new Border.all(
                                                                  width: 1),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                      child: TextFormField(
                                                        controller: txtEmail,
                                                        decoration:
                                                            InputDecoration(
                                                                prefixIcon:
                                                                    Image.asset(
                                                                  "images/gmail24.png",
                                                                ),
                                                                hintText:
                                                                    "Email"),
                                                        keyboardType:
                                                            TextInputType
                                                                .emailAddress,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      //height: 40,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 20),
                                                      child: GestureDetector(
                                                          onTap: () {
                                                            if (txtEmail.text !=
                                                                "") {
                                                              updateProfile(
                                                                      'Email',
                                                                      txtEmail
                                                                          .text)
                                                                  .then((val) {
                                                                setState(() {
                                                                  profileList[
                                                                          "email"] =
                                                                      txtEmail
                                                                          .text;
                                                                  editEmail =
                                                                      false;
                                                                });
                                                              }, onError: (e) {
                                                                setState(() {
                                                                  txtEmail.text =
                                                                      profileList[
                                                                          "email"];
                                                                  editEmail =
                                                                      false;
                                                                });
                                                              });
                                                            } else {
                                                              Fluttertoast.showToast(
                                                                  msg:
                                                                      "Please Enter Data First",
                                                                  toastLength: Toast
                                                                      .LENGTH_SHORT,
                                                                  gravity:
                                                                      ToastGravity
                                                                          .TOP,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .yellow,
                                                                  textColor:
                                                                      Colors
                                                                          .black,
                                                                  fontSize:
                                                                      15.0);
                                                            }
                                                          },
                                                          child: Icon(Icons
                                                              .done_outline)),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            txtEmail.text =
                                                                profileList[
                                                                    "email"];
                                                            editEmail = false;
                                                          });
                                                        },
                                                        child:
                                                            Icon(Icons.close))
                                                  ],
                                                ),
                                        ),
                                      ),

                                      //Website
                                      // Padding(
                                      //   padding: const EdgeInsets.only(bottom: 20),
                                      //   child: AnimatedSize(
                                      //     duration: Duration(milliseconds: 250),
                                      //     curve: Curves.easeInOut,
                                      //     vsync: this,
                                      //     child: !editWeb
                                      //         ? Row(
                                      //             children: <Widget>[
                                      //               Container(
                                      //                 width: MediaQuery.of(context)
                                      //                         .size
                                      //                         .width -
                                      //                     80,
                                      //                 child: Row(
                                      //                   crossAxisAlignment:
                                      //                       CrossAxisAlignment.center,
                                      //                   children: <Widget>[
                                      //                     Image.asset(
                                      //                         "images/profile/domain24.png"),
                                      //                     Padding(
                                      //                       padding:
                                      //                           const EdgeInsets.only(
                                      //                               left: 10),
                                      //                       child: Text(
                                      //                           memberdata.website != null
                                      //                               ? memberdata.website
                                      //                               : "",
                                      //                           style: TextStyle(
                                      //                               color:
                                      //                                   Colors.grey[600],
                                      //                               fontSize: 15,
                                      //                               fontWeight:
                                      //                                   FontWeight.w600)),
                                      //                     ),
                                      //                   ],
                                      //                 ),
                                      //               ),
                                      //               GestureDetector(
                                      //                   onTap: () {
                                      //                     setState(() {
                                      //                       editWeb = true;
                                      //                     });
                                      //                   },
                                      //                   child: Icon(Icons.edit))
                                      //             ],
                                      //           )
                                      //         : Row(
                                      //             children: <Widget>[
                                      //               Container(
                                      //                 width: MediaQuery.of(context)
                                      //                         .size
                                      //                         .width -
                                      //                     150,
                                      //                 //margin: EdgeInsets.only(top: 20),
                                      //                 decoration: BoxDecoration(
                                      //                     color: Color.fromRGBO(
                                      //                         255, 255, 255, 0.5),
                                      //                     border:
                                      //                         new Border.all(width: 1),
                                      //                     borderRadius: BorderRadius.all(
                                      //                         Radius.circular(5))),
                                      //                 child: TextFormField(
                                      //                   controller: txtWebsite,
                                      //                   decoration: InputDecoration(
                                      //                       prefixIcon: Image.asset(
                                      //                           "images/profile/domain24.png"),
                                      //                       hintText: "website"),
                                      //                   keyboardType: TextInputType.url,
                                      //                   style: TextStyle(
                                      //                       color: Colors.black),
                                      //                 ),
                                      //                 //height: 40,
                                      //               ),
                                      //               Padding(
                                      //                 padding: const EdgeInsets.symmetric(
                                      //                     horizontal: 20),
                                      //                 child: GestureDetector(
                                      //                     onTap: () {
                                      //                       if (txtWebsite.text != "") {
                                      //                         updateProfile('website',
                                      //                                 txtWebsite.text)
                                      //                             .then((val) {
                                      //                           memberdata.website =
                                      //                               txtWebsite.text;
                                      //                           setState(() {
                                      //                             editWeb = false;
                                      //                           });
                                      //                         }, onError: (e) {
                                      //                           txtWebsite.text =
                                      //                               memberdata.website;
                                      //                           setState(() {
                                      //                             editWeb = false;
                                      //                           });
                                      //                         });
                                      //                       } else {
                                      //                         Fluttertoast.showToast(
                                      //                             msg:
                                      //                                 "Please Enter Data First",
                                      //                             toastLength:
                                      //                                 Toast.LENGTH_SHORT,
                                      //                             gravity:
                                      //                                 ToastGravity.TOP,
                                      //                             backgroundColor:
                                      //                                 Colors.yellow,
                                      //                             textColor: Colors.black,
                                      //                             fontSize: 15.0);
                                      //                       }
                                      //                     },
                                      //                     child:
                                      //                         Icon(Icons.done_outline)),
                                      //               ),
                                      //               GestureDetector(
                                      //                   onTap: () {
                                      //                     txtWebsite.text =
                                      //                         memberdata.website;
                                      //                     setState(() {
                                      //                       editWeb = false;
                                      //                     });
                                      //                   },
                                      //                   child: Icon(Icons.close))
                                      //             ],
                                      //           ),
                                      //   ),
                                      // ),

                                      //Whatsapp
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: AnimatedSize(
                                          duration: Duration(milliseconds: 250),
                                          curve: Curves.easeInOut,
                                          vsync: this,
                                          child: !editWhatsapp
                                              ? Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              80,
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Image.asset(
                                                              "images/whatsapp24.png"),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10),
                                                            child: Text(
                                                                profileList["whatsApp"] !=
                                                                        null
                                                                    ? profileList[
                                                                        "whatsApp"]
                                                                    : "",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                            .grey[
                                                                        600],
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600)),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            editWhatsapp = true;
                                                          });
                                                        },
                                                        child: Icon(Icons.edit))
                                                  ],
                                                )
                                              : Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              150,
                                                      //margin: EdgeInsets.only(top: 20),
                                                      decoration: BoxDecoration(
                                                          color: Color.fromRGBO(
                                                              255,
                                                              255,
                                                              255,
                                                              0.5),
                                                          border:
                                                              new Border.all(
                                                                  width: 1),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                      child: TextFormField(
                                                        controller: txtWhatsApp,
                                                        decoration: InputDecoration(
                                                            prefixIcon: Image.asset(
                                                                "images/whatsapp24.png"),
                                                            hintText:
                                                                "Whatsapp No"),
                                                        keyboardType:
                                                            TextInputType.phone,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      //height: 40,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 20),
                                                      child: GestureDetector(
                                                          onTap: () {
                                                            if (txtWhatsApp
                                                                    .text !=
                                                                "") {
                                                              updateProfile(
                                                                      'Whatsappno',
                                                                      txtWhatsApp
                                                                          .text)
                                                                  .then((val) {
                                                                setState(() {
                                                                  profileList[
                                                                          "whatsApp"] =
                                                                      txtWhatsApp
                                                                          .text;
                                                                  editWhatsapp =
                                                                      false;
                                                                });
                                                              }, onError: (e) {
                                                                setState(() {
                                                                  txtWhatsApp
                                                                          .text =
                                                                      profileList[
                                                                          "whatsApp"];
                                                                  editWhatsapp =
                                                                      false;
                                                                });
                                                              });
                                                            } else {
                                                              Fluttertoast.showToast(
                                                                  msg:
                                                                      "Please Enter Data First",
                                                                  toastLength: Toast
                                                                      .LENGTH_SHORT,
                                                                  gravity:
                                                                      ToastGravity
                                                                          .TOP,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .yellow,
                                                                  textColor:
                                                                      Colors
                                                                          .black,
                                                                  fontSize:
                                                                      15.0);
                                                            }
                                                          },
                                                          child: Icon(Icons
                                                              .done_outline)),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            txtWhatsApp.text =
                                                                profileList[
                                                                    "whatsApp"];
                                                            editWhatsapp =
                                                                false;
                                                          });
                                                        },
                                                        child:
                                                            Icon(Icons.close))
                                                  ],
                                                ),
                                        ),
                                      ),

                                      //PAN
                                      // Padding(
                                      //   padding: const EdgeInsets.only(bottom: 20),
                                      //   child: AnimatedSize(
                                      //     duration: Duration(milliseconds: 250),
                                      //     curve: Curves.easeInOut,
                                      //     vsync: this,
                                      //     child: !editPersonalPan
                                      //         ? Row(
                                      //             children: <Widget>[
                                      //               Container(
                                      //                 width: MediaQuery.of(context)
                                      //                         .size
                                      //                         .width -
                                      //                     80,
                                      //                 child: Row(
                                      //                   crossAxisAlignment:
                                      //                       CrossAxisAlignment.center,
                                      //                   children: <Widget>[
                                      //                     Image.asset(
                                      //                         "images/profile/pan.png"),
                                      //                     Padding(
                                      //                       padding:
                                      //                           const EdgeInsets.only(
                                      //                               left: 10),
                                      //                       child: Text(
                                      //                           memberdata.PersonalPAN !=
                                      //                                   null
                                      //                               ? memberdata
                                      //                                   .PersonalPAN
                                      //                               : "",
                                      //                           style: TextStyle(
                                      //                               color:
                                      //                                   Colors.grey[600],
                                      //                               fontSize: 15,
                                      //                               fontWeight:
                                      //                                   FontWeight.w600)),
                                      //                     ),
                                      //                   ],
                                      //                 ),
                                      //               ),
                                      //               GestureDetector(
                                      //                   onTap: () {
                                      //                     setState(() {
                                      //                       editPersonalPan = true;
                                      //                     });
                                      //                   },
                                      //                   child: Icon(Icons.edit))
                                      //             ],
                                      //           )
                                      //         : Row(
                                      //             children: <Widget>[
                                      //               Container(
                                      //                 width: MediaQuery.of(context)
                                      //                         .size
                                      //                         .width -
                                      //                     150,
                                      //                 //margin: EdgeInsets.only(top: 20),
                                      //                 decoration: BoxDecoration(
                                      //                     color: Color.fromRGBO(
                                      //                         255, 255, 255, 0.5),
                                      //                     border:
                                      //                         new Border.all(width: 1),
                                      //                     borderRadius: BorderRadius.all(
                                      //                         Radius.circular(5))),
                                      //                 child: TextFormField(
                                      //                   controller: txtPersonalPAN,
                                      //                   decoration: InputDecoration(
                                      //                       prefixIcon: Image.asset(
                                      //                           "images/profile/pan.png"),
                                      //                       hintText: "PAN No"),
                                      //                   keyboardType: TextInputType.text,
                                      //                   style: TextStyle(
                                      //                       color: Colors.black),
                                      //                 ),
                                      //                 //height: 40,
                                      //               ),
                                      //               Padding(
                                      //                 padding: const EdgeInsets.symmetric(
                                      //                     horizontal: 20),
                                      //                 child: GestureDetector(
                                      //                     onTap: () {
                                      //                       if (txtPersonalPAN.text !=
                                      //                           "") {
                                      //                         updateProfile('PersonalPAN',
                                      //                                 txtPersonalPAN.text)
                                      //                             .then((val) {
                                      //                           memberdata.PersonalPAN =
                                      //                               txtPersonalPAN.text;
                                      //                           setState(() {
                                      //                             editPersonalPan = false;
                                      //                           });
                                      //                         }, onError: (e) {
                                      //                           txtPersonalPAN.text =
                                      //                               memberdata
                                      //                                   .PersonalPAN;
                                      //                           setState(() {
                                      //                             editPersonalPan = false;
                                      //                           });
                                      //                         });
                                      //                       } else {
                                      //                         Fluttertoast.showToast(
                                      //                             msg:
                                      //                                 "Please Enter Data First",
                                      //                             toastLength:
                                      //                                 Toast.LENGTH_SHORT,
                                      //                             gravity:
                                      //                                 ToastGravity.TOP,
                                      //                             backgroundColor:
                                      //                                 Colors.yellow,
                                      //                             textColor: Colors.black,
                                      //                             fontSize: 15.0);
                                      //                       }
                                      //                     },
                                      //                     child:
                                      //                         Icon(Icons.done_outline)),
                                      //               ),
                                      //               GestureDetector(
                                      //                   onTap: () {
                                      //                     txtPersonalPAN.text =
                                      //                         memberdata.PersonalPAN;
                                      //                     setState(() {
                                      //                       editPersonalPan = false;
                                      //                     });
                                      //                   },
                                      //                   child: Icon(Icons.close))
                                      //             ],
                                      //           ),
                                      //   ),
                                      // ),

                                      //Facebook
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: AnimatedSize(
                                          duration: Duration(milliseconds: 250),
                                          curve: Curves.easeInOut,
                                          vsync: this,
                                          child: !editFacebook
                                              ? Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              80,
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Image.asset(
                                                              "images/facebook24.png"),
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                110,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 10),
                                                              child: Text(
                                                                  profileList["faceBook"] !=
                                                                          null
                                                                      ? profileList[
                                                                          "faceBook"]
                                                                      : "",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                              .grey[
                                                                          600],
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600)),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            editFacebook = true;
                                                          });
                                                        },
                                                        child: Icon(Icons.edit))
                                                  ],
                                                )
                                              : Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              150,
                                                      //margin: EdgeInsets.only(top: 20),
                                                      decoration: BoxDecoration(
                                                          color: Color.fromRGBO(
                                                              255,
                                                              255,
                                                              255,
                                                              0.5),
                                                          border:
                                                              new Border.all(
                                                                  width: 1),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                      child: TextFormField(
                                                        controller:
                                                            txtFaceboook,
                                                        decoration: InputDecoration(
                                                            prefixIcon: Image.asset(
                                                                "images/facebook24.png"),
                                                            hintText:
                                                                "Facebook Page"),
                                                        keyboardType:
                                                            TextInputType.url,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      //height: 40,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 20),
                                                      child: GestureDetector(
                                                          onTap: () {
                                                            if (txtFaceboook
                                                                    .text !=
                                                                "") {
                                                              updateProfile(
                                                                      'Facebooklink',
                                                                      txtFaceboook
                                                                          .text)
                                                                  .then((val) {
                                                                setState(() {
                                                                  memberdata
                                                                          .Facebooklink =
                                                                      txtFaceboook
                                                                          .text;
                                                                  editFacebook =
                                                                      false;
                                                                });
                                                              }, onError: (e) {
                                                                setState(() {
                                                                  txtFaceboook
                                                                          .text =
                                                                      memberdata
                                                                          .Facebooklink;
                                                                  editFacebook =
                                                                      false;
                                                                });
                                                              });
                                                            } else {
                                                              Fluttertoast.showToast(
                                                                  msg:
                                                                      "Please Enter Data First",
                                                                  toastLength: Toast
                                                                      .LENGTH_SHORT,
                                                                  gravity:
                                                                      ToastGravity
                                                                          .TOP,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .yellow,
                                                                  textColor:
                                                                      Colors
                                                                          .black,
                                                                  fontSize:
                                                                      15.0);
                                                            }
                                                          },
                                                          child: Icon(Icons
                                                              .done_outline)),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            txtFaceboook.text =
                                                                memberdata
                                                                    .Facebooklink;
                                                            editFacebook =
                                                                false;
                                                          });
                                                        },
                                                        child:
                                                            Icon(Icons.close))
                                                  ],
                                                ),
                                        ),
                                      ),

                                      //Twitter
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: AnimatedSize(
                                          duration: Duration(milliseconds: 250),
                                          curve: Curves.easeInOut,
                                          vsync: this,
                                          child: !editTwitter
                                              ? Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              80,
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Image.asset(
                                                              "images/twitter24.png"),
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                110,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 10),
                                                              child: Text(
                                                                  profileList["twitter"] !=
                                                                          null
                                                                      ? profileList[
                                                                          "twitter"]
                                                                      : "",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                              .grey[
                                                                          600],
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600)),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            editTwitter = true;
                                                          });
                                                        },
                                                        child: Icon(Icons.edit))
                                                  ],
                                                )
                                              : Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              150,
                                                      //margin: EdgeInsets.only(top: 20),
                                                      decoration: BoxDecoration(
                                                          color: Color.fromRGBO(
                                                              255,
                                                              255,
                                                              255,
                                                              0.5),
                                                          border:
                                                              new Border.all(
                                                                  width: 1),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                      child: TextFormField(
                                                        controller: txtTwitter,
                                                        decoration: InputDecoration(
                                                            prefixIcon: Image.asset(
                                                                "images/twitter24.png"),
                                                            hintText:
                                                                "Twitter Page"),
                                                        keyboardType:
                                                            TextInputType.url,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      //height: 40,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 20),
                                                      child: GestureDetector(
                                                          onTap: () {
                                                            if (txtTwitter
                                                                    .text !=
                                                                "") {
                                                              updateProfile(
                                                                      'Twitter',
                                                                      txtTwitter
                                                                          .text)
                                                                  .then((val) {
                                                                setState(() {
                                                                  memberdata
                                                                          .Twitter =
                                                                      txtTwitter
                                                                          .text;
                                                                  editTwitter =
                                                                      false;
                                                                });
                                                              }, onError: (e) {
                                                                setState(() {
                                                                  txtTwitter
                                                                          .text =
                                                                      memberdata
                                                                          .Twitter;
                                                                  editTwitter =
                                                                      false;
                                                                });
                                                              });
                                                            } else {
                                                              Fluttertoast.showToast(
                                                                  msg:
                                                                      "Please Enter Data First",
                                                                  toastLength: Toast
                                                                      .LENGTH_SHORT,
                                                                  gravity:
                                                                      ToastGravity
                                                                          .TOP,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .yellow,
                                                                  textColor:
                                                                      Colors
                                                                          .black,
                                                                  fontSize:
                                                                      15.0);
                                                            }
                                                          },
                                                          child: Icon(Icons
                                                              .done_outline)),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            txtTwitter.text =
                                                                memberdata
                                                                    .Twitter;
                                                            editTwitter = false;
                                                          });
                                                        },
                                                        child:
                                                            Icon(Icons.close))
                                                  ],
                                                ),
                                        ),
                                      ),

                                      //Google
                                      // Padding(
                                      //   padding: const EdgeInsets.only(bottom: 20),
                                      //   child: AnimatedSize(
                                      //     duration: Duration(milliseconds: 250),
                                      //     curve: Curves.easeInOut,
                                      //     vsync: this,
                                      //     child: !editGoogle
                                      //         ? Row(
                                      //             children: <Widget>[
                                      //               Container(
                                      //                 width: MediaQuery.of(context)
                                      //                         .size
                                      //                         .width -
                                      //                     80,
                                      //                 child: Row(
                                      //                   crossAxisAlignment:
                                      //                       CrossAxisAlignment.center,
                                      //                   children: <Widget>[
                                      //                     Image.asset(
                                      //                         "images/social/googleplus24.png"),
                                      //                     Container(
                                      //                       width: MediaQuery.of(context)
                                      //                               .size
                                      //                               .width -
                                      //                           110,
                                      //                       child: Padding(
                                      //                         padding:
                                      //                             const EdgeInsets.only(
                                      //                                 left: 10),
                                      //                         child: Text(
                                      //                             memberdata.Google !=
                                      //                                     null
                                      //                                 ? memberdata.Google
                                      //                                 : "",
                                      //                             style: TextStyle(
                                      //                                 color: Colors
                                      //                                     .grey[600],
                                      //                                 fontSize: 15,
                                      //                                 fontWeight:
                                      //                                     FontWeight
                                      //                                         .w600)),
                                      //                       ),
                                      //                     ),
                                      //                   ],
                                      //                 ),
                                      //               ),
                                      //               GestureDetector(
                                      //                   onTap: () {
                                      //                     setState(() {
                                      //                       editGoogle = true;
                                      //                     });
                                      //                   },
                                      //                   child: Icon(Icons.edit))
                                      //             ],
                                      //           )
                                      //         : Row(
                                      //             children: <Widget>[
                                      //               Container(
                                      //                 width: MediaQuery.of(context)
                                      //                         .size
                                      //                         .width -
                                      //                     150,
                                      //                 //margin: EdgeInsets.only(top: 20),
                                      //                 decoration: BoxDecoration(
                                      //                     color: Color.fromRGBO(
                                      //                         255, 255, 255, 0.5),
                                      //                     border:
                                      //                         new Border.all(width: 1),
                                      //                     borderRadius: BorderRadius.all(
                                      //                         Radius.circular(5))),
                                      //                 child: TextFormField(
                                      //                   controller: txtGoogle,
                                      //                   decoration: InputDecoration(
                                      //                       prefixIcon: Image.asset(
                                      //                           "images/social/googleplus24.png"),
                                      //                       hintText: "Google Page"),
                                      //                   keyboardType: TextInputType.url,
                                      //                   style: TextStyle(
                                      //                       color: Colors.black),
                                      //                 ),
                                      //                 //height: 40,
                                      //               ),
                                      //               Padding(
                                      //                 padding: const EdgeInsets.symmetric(
                                      //                     horizontal: 20),
                                      //                 child: GestureDetector(
                                      //                     onTap: () {
                                      //                       if (txtGoogle.text != "") {
                                      //                         updateProfile('Google',
                                      //                                 txtGoogle.text)
                                      //                             .then((val) {
                                      //                           memberdata.Google =
                                      //                               txtGoogle.text;
                                      //                           setState(() {
                                      //                             editGoogle = false;
                                      //                           });
                                      //                         }, onError: (e) {
                                      //                           txtGoogle.text =
                                      //                               memberdata.Google;
                                      //                           setState(() {
                                      //                             editGoogle = false;
                                      //                           });
                                      //                         });
                                      //                       } else {
                                      //                         Fluttertoast.showToast(
                                      //                             msg:
                                      //                                 "Please Enter Data First",
                                      //                             toastLength:
                                      //                                 Toast.LENGTH_SHORT,
                                      //                             gravity:
                                      //                                 ToastGravity.TOP,
                                      //                             backgroundColor:
                                      //                                 Colors.yellow,
                                      //                             textColor: Colors.black,
                                      //                             fontSize: 15.0);
                                      //                       }
                                      //                     },
                                      //                     child:
                                      //                         Icon(Icons.done_outline)),
                                      //               ),
                                      //               GestureDetector(
                                      //                   onTap: () {
                                      //                     txtGoogle.text =
                                      //                         memberdata.Google;
                                      //                     setState(() {
                                      //                       editGoogle = false;
                                      //                     });
                                      //                   },
                                      //                   child: Icon(Icons.close))
                                      //             ],
                                      //           ),
                                      //   ),
                                      // ),

                                      //Linkedin
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: AnimatedSize(
                                          duration: Duration(milliseconds: 250),
                                          curve: Curves.easeInOut,
                                          vsync: this,
                                          child: !editLinkedin
                                              ? Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              80,
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Image.asset(
                                                              "images/linkedin24.png"),
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                110,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 10),
                                                              child: Text(
                                                                  profileList["linkedIn"] !=
                                                                          null
                                                                      ? profileList[
                                                                          "linkedIn"]
                                                                      : "",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                              .grey[
                                                                          600],
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600)),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            editLinkedin = true;
                                                          });
                                                        },
                                                        child: Icon(Icons.edit))
                                                  ],
                                                )
                                              : Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              150,
                                                      //margin: EdgeInsets.only(top: 20),
                                                      decoration: BoxDecoration(
                                                          color: Color.fromRGBO(
                                                              255,
                                                              255,
                                                              255,
                                                              0.5),
                                                          border:
                                                              new Border.all(
                                                                  width: 1),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                      child: TextFormField(
                                                        controller: txtLinkedin,
                                                        decoration: InputDecoration(
                                                            prefixIcon: Image.asset(
                                                                "images/linkedin24.png"),
                                                            hintText:
                                                                "Linkedin Page"),
                                                        keyboardType:
                                                            TextInputType.url,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      //height: 40,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 20),
                                                      child: GestureDetector(
                                                          onTap: () {
                                                            if (txtLinkedin
                                                                    .text !=
                                                                "") {
                                                              updateProfile(
                                                                      'Linkedin',
                                                                      txtLinkedin
                                                                          .text)
                                                                  .then((val) {
                                                                setState(() {
                                                                  memberdata
                                                                          .Linkedin =
                                                                      txtLinkedin
                                                                          .text;
                                                                  editLinkedin =
                                                                      false;
                                                                });
                                                              }, onError: (e) {
                                                                setState(() {
                                                                  txtLinkedin
                                                                          .text =
                                                                      memberdata
                                                                          .Linkedin;
                                                                  editLinkedin =
                                                                      false;
                                                                });
                                                              });
                                                            } else {
                                                              Fluttertoast.showToast(
                                                                  msg:
                                                                      "Please Enter Data First",
                                                                  toastLength: Toast
                                                                      .LENGTH_SHORT,
                                                                  gravity:
                                                                      ToastGravity
                                                                          .TOP,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .yellow,
                                                                  textColor:
                                                                      Colors
                                                                          .black,
                                                                  fontSize:
                                                                      15.0);
                                                            }
                                                          },
                                                          child: Icon(Icons
                                                              .done_outline)),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            txtLinkedin.text =
                                                                memberdata
                                                                    .Linkedin;
                                                            editLinkedin =
                                                                false;
                                                          });
                                                        },
                                                        child:
                                                            Icon(Icons.close))
                                                  ],
                                                ),
                                        ),
                                      ),

                                      //Youtube
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: AnimatedSize(
                                          duration: Duration(milliseconds: 250),
                                          curve: Curves.easeInOut,
                                          vsync: this,
                                          child: !editYoutube
                                              ? Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              80,
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Image.asset(
                                                              "images/youtube24.png"),
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                110,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 10),
                                                              child: Text(
                                                                  profileList["youTube"] !=
                                                                          null
                                                                      ? profileList[
                                                                          "youTube"]
                                                                      : "",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                              .grey[
                                                                          600],
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600)),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            editYoutube = true;
                                                          });
                                                        },
                                                        child: Icon(Icons.edit))
                                                  ],
                                                )
                                              : Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              150,
                                                      //margin: EdgeInsets.only(top: 20),
                                                      decoration: BoxDecoration(
                                                          color: Color.fromRGBO(
                                                              255,
                                                              255,
                                                              255,
                                                              0.5),
                                                          border:
                                                              new Border.all(
                                                                  width: 1),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                      child: TextFormField(
                                                        controller: txtYoutube,
                                                        decoration: InputDecoration(
                                                            prefixIcon: Image.asset(
                                                                "images/youtube24.png"),
                                                            hintText:
                                                                "Youtube Page"),
                                                        keyboardType:
                                                            TextInputType.url,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      //height: 40,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 20),
                                                      child: GestureDetector(
                                                          onTap: () {
                                                            if (txtYoutube
                                                                    .text !=
                                                                "") {
                                                              updateProfile(
                                                                      'Youtube',
                                                                      txtYoutube
                                                                          .text)
                                                                  .then((val) {
                                                                setState(() {
                                                                  memberdata
                                                                          .Youtube =
                                                                      txtYoutube
                                                                          .text;
                                                                  editYoutube =
                                                                      false;
                                                                });
                                                              }, onError: (e) {
                                                                setState(() {
                                                                  txtYoutube
                                                                          .text =
                                                                      memberdata
                                                                          .Youtube;
                                                                  editYoutube =
                                                                      false;
                                                                });
                                                              });
                                                            } else {
                                                              Fluttertoast.showToast(
                                                                  msg:
                                                                      "Please Enter Data First",
                                                                  toastLength: Toast
                                                                      .LENGTH_SHORT,
                                                                  gravity:
                                                                      ToastGravity
                                                                          .TOP,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .yellow,
                                                                  textColor:
                                                                      Colors
                                                                          .black,
                                                                  fontSize:
                                                                      15.0);
                                                            }
                                                            setState(() {
                                                              editYoutube =
                                                                  false;
                                                            });
                                                          },
                                                          child: Icon(Icons
                                                              .done_outline)),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            txtYoutube.text =
                                                                memberdata
                                                                    .Youtube;
                                                            editYoutube = false;
                                                          });
                                                        },
                                                        child:
                                                            Icon(Icons.close))
                                                  ],
                                                ),
                                        ),
                                      ),

                                      //Instagram
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: AnimatedSize(
                                          duration: Duration(milliseconds: 250),
                                          curve: Curves.easeInOut,
                                          vsync: this,
                                          child: !editInstagram
                                              ? Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              80,
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Image.asset(
                                                              "images/instagram24.png"),
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                110,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 10),
                                                              child: Text(
                                                                  profileList["instagram"] !=
                                                                          null
                                                                      ? profileList[
                                                                          "instagram"]
                                                                      : "",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                              .grey[
                                                                          600],
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600)),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            editInstagram =
                                                                true;
                                                          });
                                                        },
                                                        child: Icon(Icons.edit))
                                                  ],
                                                )
                                              : Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              150,
                                                      //margin: EdgeInsets.only(top: 20),
                                                      decoration: BoxDecoration(
                                                          color: Color.fromRGBO(
                                                              255,
                                                              255,
                                                              255,
                                                              0.5),
                                                          border:
                                                              new Border.all(
                                                                  width: 1),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                      child: TextFormField(
                                                        controller: txtIntagram,
                                                        decoration: InputDecoration(
                                                            prefixIcon: Image.asset(
                                                                "images/instagram24.png"),
                                                            hintText:
                                                                "Instagram Page"),
                                                        keyboardType:
                                                            TextInputType.url,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      //height: 40,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 20),
                                                      child: GestureDetector(
                                                          onTap: () {
                                                            if (txtIntagram
                                                                    .text !=
                                                                "") {
                                                              updateProfile(
                                                                      'Instagram',
                                                                      txtIntagram
                                                                          .text)
                                                                  .then((val) {
                                                                setState(() {
                                                                  memberdata
                                                                          .Instagram =
                                                                      txtIntagram
                                                                          .text;
                                                                  editInstagram =
                                                                      false;
                                                                });
                                                              }, onError: (e) {
                                                                setState(() {
                                                                  txtIntagram
                                                                          .text =
                                                                      memberdata
                                                                          .Instagram;
                                                                  editInstagram =
                                                                      false;
                                                                });
                                                              });
                                                            } else {
                                                              Fluttertoast.showToast(
                                                                  msg:
                                                                      "Please Enter Data First",
                                                                  toastLength: Toast
                                                                      .LENGTH_SHORT,
                                                                  gravity:
                                                                      ToastGravity
                                                                          .TOP,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .yellow,
                                                                  textColor:
                                                                      Colors
                                                                          .black,
                                                                  fontSize:
                                                                      15.0);
                                                            }
                                                          },
                                                          child: Icon(Icons
                                                              .done_outline)),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            txtIntagram.text =
                                                                memberdata
                                                                    .Instagram;
                                                            editInstagram =
                                                                false;
                                                          });
                                                        },
                                                        child:
                                                            Icon(Icons.close))
                                                  ],
                                                ),
                                        ),
                                      ),

                                      //About
                                      AnimatedSize(
                                        duration: Duration(milliseconds: 250),
                                        curve: Curves.easeInOut,
                                        vsync: this,
                                        child: !editAbout
                                            ? Row(
                                                children: <Widget>[
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            80,
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Image.asset(
                                                            "images/negotiation24.png"),
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10),
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width -
                                                              110,
                                                          child: Text(
                                                              profileList["about_business"] !=
                                                                      null
                                                                  ? profileList[
                                                                      "about_business"]
                                                                  : "",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                          .grey[
                                                                      600],
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          editAbout = true;
                                                        });
                                                      },
                                                      child: Icon(Icons.edit))
                                                ],
                                              )
                                            : Row(
                                                children: <Widget>[
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            150,
                                                    //margin: EdgeInsets.only(top: 20),
                                                    decoration: BoxDecoration(
                                                        color: Color.fromRGBO(
                                                            255, 255, 255, 0.5),
                                                        border: new Border.all(
                                                            width: 1),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5))),
                                                    child: TextFormField(
                                                      controller: txtAbout,
                                                      maxLines: 3,
                                                      decoration: InputDecoration(
                                                          prefixIcon: Image.asset(
                                                              "images/negotiation24.png"),
                                                          hintText: "About"),
                                                      keyboardType:
                                                          TextInputType.text,
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                    //height: 40,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 20),
                                                    child: GestureDetector(
                                                        onTap: () {
                                                          if (txtAbout.text !=
                                                              "") {
                                                            updateProfile(
                                                                    'About',
                                                                    txtAbout
                                                                        .text)
                                                                .then((val) {
                                                              setState(() {
                                                                memberdata
                                                                        .About =
                                                                    txtAbout
                                                                        .text;
                                                                editAbout =
                                                                    false;
                                                              });
                                                            }, onError: (e) {
                                                              setState(() {
                                                                txtAbout.text =
                                                                    memberdata
                                                                        .About;
                                                                editAbout =
                                                                    false;
                                                              });
                                                            });
                                                          } else {
                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    "Please Enter Data First",
                                                                toastLength: Toast
                                                                    .LENGTH_SHORT,
                                                                gravity:
                                                                    ToastGravity
                                                                        .TOP,
                                                                backgroundColor:
                                                                    Colors
                                                                        .yellow,
                                                                textColor:
                                                                    Colors
                                                                        .black,
                                                                fontSize: 15.0);
                                                          }
                                                        },
                                                        child: Icon(Icons
                                                            .done_outline)),
                                                  ),
                                                  GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          txtAbout.text =
                                                              memberdata.About;
                                                          editAbout = false;
                                                        });
                                                      },
                                                      child: Icon(Icons.close))
                                                ],
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.only(top: 10),
                                  height: 48,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(0))),
                                  child: MaterialButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(0.0)),
                                    color: cnst.appMaterialColor,
                                    minWidth: MediaQuery.of(context).size.width,
                                    onPressed: () {
                                      showEventDialog(context);
                                    },
                                    child: Text(
                                      "Upload Brochure",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Stack(
                            children: <Widget>[
                              AnimatedContainer(
                                duration: Duration(milliseconds: 500),
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(
                                    top: 10, left: 10, right: 10, bottom: 50),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    border: Border.all(
                                        color: Colors.grey[600], width: 0.5)),
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      /*Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Text("Company",
                                    style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600))),*/

                                      //Company
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 20, top: 10),
                                        child: AnimatedSize(
                                          duration: Duration(milliseconds: 250),
                                          curve: Curves.easeInOut,
                                          vsync: this,
                                          child: !editCompany
                                              ? Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              80,
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Image.asset(
                                                              "images/office24.png"),
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10),
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                110,
                                                            child: Text(
                                                                profileList["company_name"] !=
                                                                        ""
                                                                    ? profileList[
                                                                        "company_name"]
                                                                    : "",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                            .grey[
                                                                        600],
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600)),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            editCompany = true;
                                                          });
                                                        },
                                                        child: Icon(Icons.edit))
                                                  ],
                                                )
                                              : Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              150,
                                                      //margin: EdgeInsets.only(top: 20),
                                                      decoration: BoxDecoration(
                                                          color: Color.fromRGBO(
                                                              255,
                                                              255,
                                                              255,
                                                              0.5),
                                                          border:
                                                              new Border.all(
                                                                  width: 1),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                      child: TextFormField(
                                                        controller: txtCompany,
                                                        decoration: InputDecoration(
                                                            prefixIcon: Image.asset(
                                                                "images/office24.png"),
                                                            hintText:
                                                                "Company Name"),
                                                        keyboardType:
                                                            TextInputType.text,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      //height: 40,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 20),
                                                      child: GestureDetector(
                                                          onTap: () {
                                                            if (txtCompany
                                                                    .text !=
                                                                "") {
                                                              updateProfile(
                                                                      'Company',
                                                                      txtCompany
                                                                          .text)
                                                                  .then((val) {
                                                                setState(() {
                                                                  memberdata
                                                                          .Company =
                                                                      txtCompany
                                                                          .text;
                                                                  editCompany =
                                                                      false;
                                                                });
                                                              }, onError: (e) {
                                                                setState(() {
                                                                  txtCompany
                                                                          .text =
                                                                      memberdata
                                                                          .Company;
                                                                  editCompany =
                                                                      false;
                                                                });
                                                              });
                                                            } else {
                                                              Fluttertoast.showToast(
                                                                  msg:
                                                                      "Please Enter Data First",
                                                                  toastLength: Toast
                                                                      .LENGTH_SHORT,
                                                                  gravity:
                                                                      ToastGravity
                                                                          .TOP,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .yellow,
                                                                  textColor:
                                                                      Colors
                                                                          .black,
                                                                  fontSize:
                                                                      15.0);
                                                            }
                                                          },
                                                          child: Icon(Icons
                                                              .done_outline)),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            txtCompany.text =
                                                                memberdata
                                                                    .Company;
                                                            editCompany = false;
                                                          });
                                                        },
                                                        child:
                                                            Icon(Icons.close))
                                                  ],
                                                ),
                                        ),
                                      ),

                                      //Role
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: AnimatedSize(
                                          duration: Duration(milliseconds: 250),
                                          curve: Curves.easeInOut,
                                          vsync: this,
                                          child: !editRole
                                              ? Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              80,
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Image.asset(
                                                              "images/role24.png"),
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10),
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                110,
                                                            child: Text(
                                                                memberdata.Role !=
                                                                        null
                                                                    ? memberdata
                                                                        .Role
                                                                    : "",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                            .grey[
                                                                        600],
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600)),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            editRole = true;
                                                          });
                                                        },
                                                        child: Icon(Icons.edit))
                                                  ],
                                                )
                                              : Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              150,
                                                      //margin: EdgeInsets.only(top: 20),
                                                      decoration: BoxDecoration(
                                                          color: Color.fromRGBO(
                                                              255,
                                                              255,
                                                              255,
                                                              0.5),
                                                          border:
                                                              new Border.all(
                                                                  width: 1),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                      child: TextFormField(
                                                        controller: txtRole,
                                                        decoration: InputDecoration(
                                                            prefixIcon: Image.asset(
                                                                "images/role24.png"),
                                                            hintText: "Role"),
                                                        keyboardType:
                                                            TextInputType.text,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      //height: 40,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 20),
                                                      child: GestureDetector(
                                                          onTap: () {
                                                            if (txtRole.text !=
                                                                "") {
                                                              updateProfile(
                                                                      'Role',
                                                                      txtRole
                                                                          .text)
                                                                  .then((val) {
                                                                setState(() {
                                                                  memberdata
                                                                          .Role =
                                                                      txtRole
                                                                          .text;
                                                                  editRole =
                                                                      false;
                                                                });
                                                              }, onError: (e) {
                                                                setState(() {
                                                                  txtRole.text =
                                                                      memberdata
                                                                          .Role;
                                                                  editRole =
                                                                      false;
                                                                });
                                                              });
                                                            } else {
                                                              Fluttertoast.showToast(
                                                                  msg:
                                                                      "Please Enter Data First",
                                                                  toastLength: Toast
                                                                      .LENGTH_SHORT,
                                                                  gravity:
                                                                      ToastGravity
                                                                          .TOP,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .yellow,
                                                                  textColor:
                                                                      Colors
                                                                          .black,
                                                                  fontSize:
                                                                      15.0);
                                                            }
                                                          },
                                                          child: Icon(Icons
                                                              .done_outline)),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            txtRole.text =
                                                                memberdata.Role;
                                                            editRole = false;
                                                          });
                                                        },
                                                        child:
                                                            Icon(Icons.close))
                                                  ],
                                                ),
                                        ),
                                      ),

                                      //Phone
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: AnimatedSize(
                                          duration: Duration(milliseconds: 250),
                                          curve: Curves.easeInOut,
                                          vsync: this,
                                          child: !editPhone
                                              ? Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              80,
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Image.asset(
                                                              "images/telephoneold24.png"),
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10),
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                110,
                                                            child: Text(
                                                                txtMobile.text !=
                                                                        ""
                                                                    ? txtMobile
                                                                        .text
                                                                    : "",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                            .grey[
                                                                        600],
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600)),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            editPhone = true;
                                                          });
                                                        },
                                                        child: Icon(Icons.edit))
                                                  ],
                                                )
                                              : Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              150,
                                                      //margin: EdgeInsets.only(top: 20),
                                                      decoration: BoxDecoration(
                                                          color: Color.fromRGBO(
                                                              255,
                                                              255,
                                                              255,
                                                              0.5),
                                                          border:
                                                              new Border.all(
                                                                  width: 1),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                      child: TextFormField(
                                                        controller: txtPhone,
                                                        decoration: InputDecoration(
                                                            prefixIcon: Image.asset(
                                                                "images/telephoneold24.png"),
                                                            hintText: "Phone"),
                                                        keyboardType:
                                                            TextInputType.phone,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      //height: 40,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 20),
                                                      child: GestureDetector(
                                                          onTap: () {
                                                            if (txtPhone.text !=
                                                                "") {
                                                              updateProfile(
                                                                      'CompanyPhone',
                                                                      txtPhone
                                                                          .text)
                                                                  .then((val) {
                                                                setState(() {
                                                                  txtMobile
                                                                          .text =
                                                                      txtPhone
                                                                          .text;
                                                                  editPhone =
                                                                      false;
                                                                });
                                                              }, onError: (e) {
                                                                setState(() {
                                                                  txtPhone.text =
                                                                      txtMobile
                                                                          .text;
                                                                  editPhone =
                                                                      false;
                                                                });
                                                              });
                                                            } else {
                                                              Fluttertoast.showToast(
                                                                  msg:
                                                                      "Please Enter Data First",
                                                                  toastLength: Toast
                                                                      .LENGTH_SHORT,
                                                                  gravity:
                                                                      ToastGravity
                                                                          .TOP,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .yellow,
                                                                  textColor:
                                                                      Colors
                                                                          .black,
                                                                  fontSize:
                                                                      15.0);
                                                            }
                                                          },
                                                          child: Icon(Icons
                                                              .done_outline)),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            txtPhone.text =
                                                                memberdata
                                                                    .CompanyPhone;
                                                            editPhone = false;
                                                          });
                                                        },
                                                        child:
                                                            Icon(Icons.close))
                                                  ],
                                                ),
                                        ),
                                      ),

                                      //PAN
                                      // Padding(
                                      //   padding: const EdgeInsets.only(bottom: 20),
                                      //   child: AnimatedSize(
                                      //     duration: Duration(milliseconds: 250),
                                      //     curve: Curves.easeInOut,
                                      //     vsync: this,
                                      //     child: !editCompanyPan
                                      //         ? Row(
                                      //             children: <Widget>[
                                      //               Container(
                                      //                 width: MediaQuery.of(context)
                                      //                         .size
                                      //                         .width -
                                      //                     80,
                                      //                 child: Row(
                                      //                   crossAxisAlignment:
                                      //                       CrossAxisAlignment.center,
                                      //                   children: <Widget>[
                                      //                     Image.asset(
                                      //                         "images/profile/pan.png"),
                                      //                     Padding(
                                      //                       padding:
                                      //                           const EdgeInsets.only(
                                      //                               left: 10),
                                      //                       child: Text(
                                      //                           memberdata.CompanyPAN !=
                                      //                                   null
                                      //                               ? memberdata
                                      //                                   .CompanyPAN
                                      //                               : "",
                                      //                           style: TextStyle(
                                      //                               color:
                                      //                                   Colors.grey[600],
                                      //                               fontSize: 15,
                                      //                               fontWeight:
                                      //                                   FontWeight.w600)),
                                      //                     ),
                                      //                   ],
                                      //                 ),
                                      //               ),
                                      //               GestureDetector(
                                      //                   onTap: () {
                                      //                     setState(() {
                                      //                       editCompanyPan = true;
                                      //                     });
                                      //                   },
                                      //                   child: Icon(Icons.edit))
                                      //             ],
                                      //           )
                                      //         : Row(
                                      //             children: <Widget>[
                                      //               Container(
                                      //                 width: MediaQuery.of(context)
                                      //                         .size
                                      //                         .width -
                                      //                     150,
                                      //                 //margin: EdgeInsets.only(top: 20),
                                      //                 decoration: BoxDecoration(
                                      //                     color: Color.fromRGBO(
                                      //                         255, 255, 255, 0.5),
                                      //                     border:
                                      //                         new Border.all(width: 1),
                                      //                     borderRadius: BorderRadius.all(
                                      //                         Radius.circular(5))),
                                      //                 child: TextFormField(
                                      //                   controller: txtCompanyPAN,
                                      //                   decoration: InputDecoration(
                                      //                       prefixIcon: Image.asset(
                                      //                           "images/profile/pan.png"),
                                      //                       hintText: "PAN No"),
                                      //                   keyboardType: TextInputType.text,
                                      //                   style: TextStyle(
                                      //                       color: Colors.black),
                                      //                 ),
                                      //                 //height: 40,
                                      //               ),
                                      //               Padding(
                                      //                 padding: const EdgeInsets.symmetric(
                                      //                     horizontal: 20),
                                      //                 child: GestureDetector(
                                      //                     onTap: () {
                                      //                       if (txtCompanyPAN.text !=
                                      //                           "") {
                                      //                         updateProfile('CompanyPAN',
                                      //                                 txtCompanyPAN.text)
                                      //                             .then((val) {
                                      //                           memberdata.CompanyPAN =
                                      //                               txtCompanyPAN.text;
                                      //                           setState(() {
                                      //                             editCompanyPan = false;
                                      //                           });
                                      //                         }, onError: (e) {
                                      //                           txtCompanyPAN.text =
                                      //                               memberdata.CompanyPAN;
                                      //                           setState(() {
                                      //                             editCompanyPan = false;
                                      //                           });
                                      //                         });
                                      //                       } else {
                                      //                         Fluttertoast.showToast(
                                      //                             msg:
                                      //                                 "Please Enter Data First",
                                      //                             toastLength:
                                      //                                 Toast.LENGTH_SHORT,
                                      //                             gravity:
                                      //                                 ToastGravity.TOP,
                                      //                             backgroundColor:
                                      //                                 Colors.yellow,
                                      //                             textColor: Colors.black,
                                      //                             fontSize: 15.0);
                                      //                       }
                                      //                     },
                                      //                     child:
                                      //                         Icon(Icons.done_outline)),
                                      //               ),
                                      //               GestureDetector(
                                      //                   onTap: () {
                                      //                     txtCompanyPAN.text =
                                      //                         memberdata.CompanyPAN;
                                      //                     setState(() {
                                      //                       editCompanyPan = false;
                                      //                     });
                                      //                   },
                                      //                   child: Icon(Icons.close))
                                      //             ],
                                      //           ),
                                      //   ),
                                      // ),

                                      //GST
                                      // Padding(
                                      //   padding: const EdgeInsets.only(bottom: 20),
                                      //   child: AnimatedSize(
                                      //     duration: Duration(milliseconds: 250),
                                      //     curve: Curves.easeInOut,
                                      //     vsync: this,
                                      //     child: !editCompanyGst
                                      //         ? Row(
                                      //             children: <Widget>[
                                      //               Container(
                                      //                 width: MediaQuery.of(context)
                                      //                         .size
                                      //                         .width -
                                      //                     80,
                                      //                 child: Row(
                                      //                   crossAxisAlignment:
                                      //                       CrossAxisAlignment.center,
                                      //                   children: <Widget>[
                                      //                     Image.asset(
                                      //                         "images/profile/gst.png",
                                      //                         height: 24,
                                      //                         width: 24),
                                      //                     Padding(
                                      //                       padding:
                                      //                           const EdgeInsets.only(
                                      //                               left: 10),
                                      //                       child: Text(
                                      //                           memberdata.GstNo != null
                                      //                               ? memberdata.GstNo
                                      //                               : "",
                                      //                           style: TextStyle(
                                      //                               color:
                                      //                                   Colors.grey[600],
                                      //                               fontSize: 15,
                                      //                               fontWeight:
                                      //                                   FontWeight.w600)),
                                      //                     ),
                                      //                   ],
                                      //                 ),
                                      //               ),
                                      //               GestureDetector(
                                      //                   onTap: () {
                                      //                     setState(() {
                                      //                       editCompanyGst = true;
                                      //                     });
                                      //                   },
                                      //                   child: Icon(Icons.edit))
                                      //             ],
                                      //           )
                                      //         : Row(
                                      //             children: <Widget>[
                                      //               Container(
                                      //                 width: MediaQuery.of(context)
                                      //                         .size
                                      //                         .width -
                                      //                     150,
                                      //                 //margin: EdgeInsets.only(top: 20),
                                      //                 decoration: BoxDecoration(
                                      //                     color: Color.fromRGBO(
                                      //                         255, 255, 255, 0.5),
                                      //                     border:
                                      //                         new Border.all(width: 1),
                                      //                     borderRadius: BorderRadius.all(
                                      //                         Radius.circular(5))),
                                      //                 child: TextFormField(
                                      //                   controller: txtGstNo,
                                      //                   decoration: InputDecoration(
                                      //                       prefixIcon: Image.asset(
                                      //                           "images/profile/gst.png",
                                      //                           height: 10,
                                      //                           width: 10),
                                      //                       hintText: "GST No"),
                                      //                   keyboardType: TextInputType.text,
                                      //                   style: TextStyle(
                                      //                       color: Colors.black),
                                      //                 ),
                                      //                 //height: 40,
                                      //               ),
                                      //               Padding(
                                      //                 padding: const EdgeInsets.symmetric(
                                      //                     horizontal: 20),
                                      //                 child: GestureDetector(
                                      //                     onTap: () {
                                      //                       if (txtGstNo.text != "") {
                                      //                         updateProfile('GstNo',
                                      //                                 txtGstNo.text)
                                      //                             .then((val) {
                                      //                           memberdata.GstNo =
                                      //                               txtGstNo.text;
                                      //                           setState(() {
                                      //                             editCompanyGst = false;
                                      //                           });
                                      //                         }, onError: (e) {
                                      //                           txtGstNo.text =
                                      //                               memberdata.GstNo;
                                      //                           setState(() {
                                      //                             editCompanyGst = false;
                                      //                           });
                                      //                         });
                                      //                       } else {
                                      //                         Fluttertoast.showToast(
                                      //                             msg:
                                      //                                 "Please Enter Data First",
                                      //                             toastLength:
                                      //                                 Toast.LENGTH_SHORT,
                                      //                             gravity:
                                      //                                 ToastGravity.TOP,
                                      //                             backgroundColor:
                                      //                                 Colors.yellow,
                                      //                             textColor: Colors.black,
                                      //                             fontSize: 15.0);
                                      //                       }
                                      //                     },
                                      //                     child:
                                      //                         Icon(Icons.done_outline)),
                                      //               ),
                                      //               GestureDetector(
                                      //                   onTap: () {
                                      //                     txtGstNo.text =
                                      //                         memberdata.GstNo;
                                      //                     setState(() {
                                      //                       editCompanyGst = false;
                                      //                     });
                                      //                   },
                                      //                   child: Icon(Icons.close))
                                      //             ],
                                      //           ),
                                      //   ),
                                      // ),

                                      //MAP
                                      // Padding(
                                      //   padding: const EdgeInsets.only(bottom: 20),
                                      //   child: AnimatedSize(
                                      //     duration: Duration(milliseconds: 250),
                                      //     curve: Curves.easeInOut,
                                      //     vsync: this,
                                      //     child: !editCompanyMap
                                      //         ? Row(
                                      //             children: <Widget>[
                                      //               Container(
                                      //                 width: MediaQuery.of(context)
                                      //                         .size
                                      //                         .width -
                                      //                     80,
                                      //                 child: Row(
                                      //                   crossAxisAlignment:
                                      //                       CrossAxisAlignment.center,
                                      //                   children: <Widget>[
                                      //                     Image.asset(
                                      //                         "images/profile/mapRoute24.png",
                                      //                         height: 24,
                                      //                         width: 24),
                                      //                     Padding(
                                      //                       padding:
                                      //                           const EdgeInsets.only(
                                      //                               left: 10),
                                      //                       child: GestureDetector(
                                      //                         onTap: () {
                                      //                           String url =
                                      //                               'google.navigation:q=${txtMap.text}';
                                      //                           print('Map Url : $url');
                                      //                           launch(url);
                                      //                         },
                                      //                         child: Text(
                                      //                             memberdata.GMap != null
                                      //                                 ? memberdata.GMap
                                      //                                 : "",
                                      //                             style: TextStyle(
                                      //                                 color: Colors.blue,
                                      //                                 fontSize: 15,
                                      //                                 fontWeight:
                                      //                                     FontWeight
                                      //                                         .w600)),
                                      //                       ),
                                      //                     ),
                                      //                   ],
                                      //                 ),
                                      //               ),
                                      //               GestureDetector(
                                      //                   onTap: () {
                                      //                     setState(() {
                                      //                       editCompanyMap = true;
                                      //                     });
                                      //                   },
                                      //                   child: Icon(Icons.edit))
                                      //             ],
                                      //           )
                                      //         : Row(
                                      //             children: <Widget>[
                                      //               Container(
                                      //                 width: MediaQuery.of(context)
                                      //                         .size
                                      //                         .width -
                                      //                     180,
                                      //                 //margin: EdgeInsets.only(top: 20),
                                      //                 decoration: BoxDecoration(
                                      //                     color: Color.fromRGBO(
                                      //                         255, 255, 255, 0.5),
                                      //                     border:
                                      //                         new Border.all(width: 1),
                                      //                     borderRadius: BorderRadius.all(
                                      //                         Radius.circular(5))),
                                      //                 child: TextFormField(
                                      //                   controller: txtMap,
                                      //                   maxLines: 2,
                                      //                   decoration: InputDecoration(
                                      //                       prefixIcon: Image.asset(
                                      //                           "images/profile/mapRoute24.png",
                                      //                           height: 24,
                                      //                           width: 24),
                                      //                       hintText: "Map Location"),
                                      //                   keyboardType: TextInputType.text,
                                      //                   style: TextStyle(
                                      //                       color: Colors.black),
                                      //                 ),
                                      //                 //height: 40,
                                      //               ),
                                      //               Padding(
                                      //                 padding:
                                      //                     const EdgeInsets.only(left: 15),
                                      //                 child: GestureDetector(
                                      //                     onTap: () async {
                                      //                       setState(() {
                                      //                         isLoading = true;
                                      //                       });
                                      //                       try {
                                      //                         location
                                      //                             .getLocation()
                                      //                             .then((val) {
                                      //                           if (val != null) {
                                      //                             txtMap.text = val
                                      //                                     .latitude
                                      //                                     .toString() +
                                      //                                 ',' +
                                      //                                 val.longitude
                                      //                                     .toString();
                                      //                           }
                                      //                           setState(() {
                                      //                             isLoading = false;
                                      //                           });
                                      //                         });
                                      //                       } on PlatformException catch (e) {
                                      //                         if (e.code ==
                                      //                             'PERMISSION_DENIED') {
                                      //                           print(
                                      //                               'Permission denied');
                                      //                         }
                                      //                         setState(() {
                                      //                           isLoading = false;
                                      //                         });
                                      //                       }
                                      //                     },
                                      //                     child: Image.asset(
                                      //                         "images/profile/google24.png")),
                                      //               ),
                                      //               Padding(
                                      //                 padding: const EdgeInsets.symmetric(
                                      //                     horizontal: 20),
                                      //                 child: GestureDetector(
                                      //                     onTap: () {
                                      //                       if (txtMap.text != "") {
                                      //                         updateProfile(
                                      //                                 'Map', txtMap.text)
                                      //                             .then((val) {
                                      //                           memberdata.GMap =
                                      //                               txtMap.text;
                                      //                           setState(() {
                                      //                             editCompanyMap = false;
                                      //                           });
                                      //                         }, onError: (e) {
                                      //                           txtMap.text =
                                      //                               memberdata.GMap;
                                      //                           setState(() {
                                      //                             editCompanyMap = false;
                                      //                           });
                                      //                         });
                                      //                       } else {
                                      //                         Fluttertoast.showToast(
                                      //                             msg:
                                      //                                 "Please Enter Data First",
                                      //                             toastLength:
                                      //                                 Toast.LENGTH_SHORT,
                                      //                             gravity:
                                      //                                 ToastGravity.TOP,
                                      //                             backgroundColor:
                                      //                                 Colors.yellow,
                                      //                             textColor: Colors.black,
                                      //                             fontSize: 15.0);
                                      //                       }
                                      //                     },
                                      //                     child:
                                      //                         Icon(Icons.done_outline)),
                                      //               ),
                                      //               GestureDetector(
                                      //                   onTap: () {
                                      //                     txtMap.text = memberdata.GMap;
                                      //                     setState(() {
                                      //                       editCompanyMap = false;
                                      //                     });
                                      //                   },
                                      //                   child: Icon(Icons.close))
                                      //             ],
                                      //           ),
                                      //   ),
                                      // ),

                                      //Company Email
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: AnimatedSize(
                                          duration: Duration(milliseconds: 250),
                                          curve: Curves.easeInOut,
                                          vsync: this,
                                          child: !editCompanyEmail
                                              ? Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              80,
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Image.asset(
                                                              "images/gmail24.png"),
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10),
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                110,
                                                            child: Text(
                                                                txtEmail != ""
                                                                    ? txtEmail
                                                                    : "",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                            .grey[
                                                                        600],
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600)),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            editCompanyEmail =
                                                                true;
                                                          });
                                                        },
                                                        child: Icon(Icons.edit))
                                                  ],
                                                )
                                              : Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              150,
                                                      //margin: EdgeInsets.only(top: 20),
                                                      decoration: BoxDecoration(
                                                          color: Color.fromRGBO(
                                                              255,
                                                              255,
                                                              255,
                                                              0.5),
                                                          border:
                                                              new Border.all(
                                                                  width: 1),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                      child: TextFormField(
                                                        controller:
                                                            txtCompanyEmail,
                                                        decoration: InputDecoration(
                                                            prefixIcon: Image.asset(
                                                                "images/gmail24.png"),
                                                            hintText: "mail"),
                                                        keyboardType:
                                                            TextInputType
                                                                .emailAddress,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      //height: 40,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 20),
                                                      child: GestureDetector(
                                                          onTap: () {
                                                            if (txtCompanyEmail
                                                                    .text !=
                                                                "") {
                                                              updateProfile(
                                                                      'CompanyEmail',
                                                                      txtCompanyEmail
                                                                          .text)
                                                                  .then((val) {
                                                                setState(() {
                                                                  txtEmail.text =
                                                                      txtCompanyEmail
                                                                          .text;
                                                                  editCompanyEmail =
                                                                      false;
                                                                });
                                                              }, onError: (e) {
                                                                setState(() {
                                                                  txtCompanyEmail
                                                                          .text =
                                                                      txtCompanyEmail
                                                                          .text;
                                                                  editCompanyEmail =
                                                                      false;
                                                                });
                                                              });
                                                            } else {
                                                              Fluttertoast.showToast(
                                                                  msg:
                                                                      "Please Enter Data First",
                                                                  toastLength: Toast
                                                                      .LENGTH_SHORT,
                                                                  gravity:
                                                                      ToastGravity
                                                                          .TOP,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .yellow,
                                                                  textColor:
                                                                      Colors
                                                                          .black,
                                                                  fontSize:
                                                                      15.0);
                                                            }
                                                          },
                                                          child: Icon(Icons
                                                              .done_outline)),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            txtCompanyEmail
                                                                    .text =
                                                                txtCompanyEmail
                                                                    .text;
                                                            editCompanyEmail =
                                                                false;
                                                          });
                                                        },
                                                        child:
                                                            Icon(Icons.close))
                                                  ],
                                                ),
                                        ),
                                      ),

                                      //Company Website
                                      // Padding(
                                      //   padding: const EdgeInsets.only(bottom: 20),
                                      //   child: AnimatedSize(
                                      //     duration: Duration(milliseconds: 250),
                                      //     curve: Curves.easeInOut,
                                      //     vsync: this,
                                      //     child: !editCompanyUrl
                                      //         ? Row(
                                      //             children: <Widget>[
                                      //               Container(
                                      //                 width: MediaQuery.of(context)
                                      //                         .size
                                      //                         .width -
                                      //                     80,
                                      //                 child: Row(
                                      //                   crossAxisAlignment:
                                      //                       CrossAxisAlignment.center,
                                      //                   children: <Widget>[
                                      //                     Image.asset(
                                      //                         "images/profile/domain24.png"),
                                      //                     Container(
                                      //                       padding:
                                      //                           const EdgeInsets.only(
                                      //                               left: 10),
                                      //                       width: MediaQuery.of(context)
                                      //                               .size
                                      //                               .width -
                                      //                           110,
                                      //                       child: Text(
                                      //                           memberdata.CompanyUrl !=
                                      //                                   null
                                      //                               ? memberdata
                                      //                                   .CompanyUrl
                                      //                               : "",
                                      //                           style: TextStyle(
                                      //                               color:
                                      //                                   Colors.grey[600],
                                      //                               fontSize: 15,
                                      //                               fontWeight:
                                      //                                   FontWeight.w600)),
                                      //                     ),
                                      //                   ],
                                      //                 ),
                                      //               ),
                                      //               GestureDetector(
                                      //                   onTap: () {
                                      //                     setState(() {
                                      //                       editCompanyUrl = true;
                                      //                     });
                                      //                   },
                                      //                   child: Icon(Icons.edit))
                                      //             ],
                                      //           )
                                      //         : Row(
                                      //             children: <Widget>[
                                      //               Container(
                                      //                 width: MediaQuery.of(context)
                                      //                         .size
                                      //                         .width -
                                      //                     150,
                                      //                 //margin: EdgeInsets.only(top: 20),
                                      //                 decoration: BoxDecoration(
                                      //                     color: Color.fromRGBO(
                                      //                         255, 255, 255, 0.5),
                                      //                     border:
                                      //                         new Border.all(width: 1),
                                      //                     borderRadius: BorderRadius.all(
                                      //                         Radius.circular(5))),
                                      //                 child: TextFormField(
                                      //                   controller: txtCompanyUrl,
                                      //                   decoration: InputDecoration(
                                      //                       prefixIcon: Image.asset(
                                      //                           "images/profile/domain24.png"),
                                      //                       hintText: "Website"),
                                      //                   keyboardType: TextInputType.url,
                                      //                   style: TextStyle(
                                      //                       color: Colors.black),
                                      //                 ),
                                      //                 //height: 40,
                                      //               ),
                                      //               Padding(
                                      //                 padding: const EdgeInsets.symmetric(
                                      //                     horizontal: 20),
                                      //                 child: GestureDetector(
                                      //                     onTap: () {
                                      //                       if (txtCompanyUrl.text !=
                                      //                           "") {
                                      //                         updateProfile('CompanyUrl',
                                      //                                 txtCompanyUrl.text)
                                      //                             .then((val) {
                                      //                           memberdata.CompanyUrl =
                                      //                               txtCompanyUrl.text;
                                      //                           setState(() {
                                      //                             editCompanyUrl = false;
                                      //                           });
                                      //                         }, onError: (e) {
                                      //                           txtCompanyUrl.text =
                                      //                               memberdata.CompanyUrl;
                                      //                           setState(() {
                                      //                             editCompanyUrl = false;
                                      //                           });
                                      //                         });
                                      //                       } else {
                                      //                         Fluttertoast.showToast(
                                      //                             msg:
                                      //                                 "Please Enter Data First",
                                      //                             toastLength:
                                      //                                 Toast.LENGTH_SHORT,
                                      //                             gravity:
                                      //                                 ToastGravity.TOP,
                                      //                             backgroundColor:
                                      //                                 Colors.yellow,
                                      //                             textColor: Colors.black,
                                      //                             fontSize: 15.0);
                                      //                       }
                                      //                     },
                                      //                     child:
                                      //                         Icon(Icons.done_outline)),
                                      //               ),
                                      //               GestureDetector(
                                      //                   onTap: () {
                                      //                     txtCompanyUrl.text =
                                      //                         memberdata.CompanyUrl;
                                      //                     setState(() {
                                      //                       editCompanyUrl = false;
                                      //                     });
                                      //                   },
                                      //                   child: Icon(Icons.close))
                                      //             ],
                                      //           ),
                                      //   ),
                                      // ),

                                      //Comapny Address
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: AnimatedSize(
                                          duration: Duration(milliseconds: 250),
                                          curve: Curves.easeInOut,
                                          vsync: this,
                                          child: !editCompanyAddress
                                              ? Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              80,
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Image.asset(
                                                              "images/google24.png"),
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10),
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                110,
                                                            child: Text(
                                                                txtAddress.text !=
                                                                        ""
                                                                    ? txtAddress
                                                                        .text
                                                                    : "",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                            .grey[
                                                                        600],
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600)),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            editCompanyAddress =
                                                                true;
                                                          });
                                                        },
                                                        child: Icon(Icons.edit))
                                                  ],
                                                )
                                              : Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              180,
                                                      //margin: EdgeInsets.only(top: 20),
                                                      decoration: BoxDecoration(
                                                          color: Color.fromRGBO(
                                                              255,
                                                              255,
                                                              255,
                                                              0.5),
                                                          border:
                                                              new Border.all(
                                                                  width: 1),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                      child: TextFormField(
                                                        maxLines: 5,
                                                        controller: txtAddress,
                                                        decoration: InputDecoration(
                                                            prefixIcon: Image.asset(
                                                                "images/google24.png"),
                                                            hintText:
                                                                "Address"),
                                                        keyboardType:
                                                            TextInputType.text,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      //height: 40,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 15),
                                                      child: GestureDetector(
                                                          onTap: () {
                                                            try {
                                                              setState(() {
                                                                isLoading =
                                                                    true;
                                                              });
                                                              location
                                                                  .getLocation()
                                                                  .then((val) {
                                                                if (val !=
                                                                    null) {
                                                                  final coordinates =
                                                                      new Coordinates(
                                                                          val.latitude,
                                                                          val.longitude);
                                                                  Geocoder.local
                                                                      .findAddressesFromCoordinates(
                                                                          coordinates)
                                                                      .then(
                                                                          (addresses) {
                                                                    if (addresses !=
                                                                        null) {
                                                                      var first =
                                                                          addresses
                                                                              .first;
                                                                      print(
                                                                          "Address : ${first.featureName} : ${first.addressLine}");
                                                                      txtAddress.text = first
                                                                          .addressLine
                                                                          .toString();
                                                                    }
                                                                    setState(
                                                                        () {
                                                                      isLoading =
                                                                          false;
                                                                    });
                                                                  });
                                                                }
                                                              });
                                                            } on PlatformException catch (e) {
                                                              if (e.code ==
                                                                  'PERMISSION_DENIED') {
                                                                print(
                                                                    'Permission denied');
                                                              }
                                                              setState(() {
                                                                isLoading =
                                                                    false;
                                                              });
                                                            }
                                                          },
                                                          child: Image.asset(
                                                              "images/google24.png")),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 20),
                                                      child: GestureDetector(
                                                          onTap: () {
                                                            if (txtAddress
                                                                    .text !=
                                                                "") {
                                                              updateProfile(
                                                                      'CompanyAddress',
                                                                      txtAddress
                                                                          .text)
                                                                  .then((val) {
                                                                setState(() {
                                                                  txtAddress
                                                                          .text =
                                                                      txtAddress
                                                                          .text;
                                                                  editCompanyAddress =
                                                                      false;
                                                                });
                                                              }, onError: (e) {
                                                                setState(() {
                                                                  txtAddress
                                                                          .text =
                                                                      txtAddress
                                                                          .text;
                                                                  editCompanyAddress =
                                                                      false;
                                                                });
                                                              });
                                                            } else {
                                                              Fluttertoast.showToast(
                                                                  msg:
                                                                      "Please Enter Data First",
                                                                  toastLength: Toast
                                                                      .LENGTH_SHORT,
                                                                  gravity:
                                                                      ToastGravity
                                                                          .TOP,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .yellow,
                                                                  textColor:
                                                                      Colors
                                                                          .black,
                                                                  fontSize:
                                                                      15.0);
                                                            }
                                                          },
                                                          child: Icon(Icons
                                                              .done_outline)),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            txtAddress.text =
                                                                txtAddress.text;
                                                            editCompanyAddress =
                                                                false;
                                                          });
                                                        },
                                                        child:
                                                            Icon(Icons.close))
                                                  ],
                                                ),
                                        ),
                                      ),

                                      //About
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: AnimatedSize(
                                          duration: Duration(milliseconds: 250),
                                          curve: Curves.easeInOut,
                                          vsync: this,
                                          child: !editCompanyAbout
                                              ? Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              80,
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Image.asset(
                                                              "images/negotiation24.png"),
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10),
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                110,
                                                            child: Text(
                                                                txtAboutCompany
                                                                            .text !=
                                                                        ""
                                                                    ? txtAboutCompany
                                                                        .text
                                                                    : "",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                            .grey[
                                                                        600],
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600)),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            editCompanyAbout =
                                                                true;
                                                          });
                                                        },
                                                        child: Icon(Icons.edit))
                                                  ],
                                                )
                                              : Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              150,
                                                      //margin: EdgeInsets.only(top: 20),
                                                      decoration: BoxDecoration(
                                                          color: Color.fromRGBO(
                                                              255,
                                                              255,
                                                              255,
                                                              0.5),
                                                          border:
                                                              new Border.all(
                                                                  width: 1),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                      child: TextFormField(
                                                        controller:
                                                            txtAboutCompany,
                                                        maxLines: 3,
                                                        decoration: InputDecoration(
                                                            prefixIcon: Image.asset(
                                                                "images/negotiation24.png"),
                                                            hintText:
                                                                "About Company"),
                                                        keyboardType:
                                                            TextInputType.text,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      //height: 40,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 20),
                                                      child: GestureDetector(
                                                          onTap: () {
                                                            if (txtAboutCompany
                                                                    .text !=
                                                                "") {
                                                              updateProfile(
                                                                      'AboutCompany',
                                                                      txtAboutCompany
                                                                          .text)
                                                                  .then((val) {
                                                                setState(() {
                                                                  txtAboutCompany
                                                                          .text =
                                                                      txtAboutCompany
                                                                          .text;
                                                                  editCompanyAbout =
                                                                      false;
                                                                });
                                                              }, onError: (e) {
                                                                setState(() {
                                                                  txtAboutCompany
                                                                          .text =
                                                                      txtAboutCompany
                                                                          .text;
                                                                  editCompanyAbout =
                                                                      false;
                                                                });
                                                              });
                                                            } else {
                                                              Fluttertoast.showToast(
                                                                  msg:
                                                                      "Please Enter Data First",
                                                                  toastLength: Toast
                                                                      .LENGTH_SHORT,
                                                                  gravity:
                                                                      ToastGravity
                                                                          .TOP,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .yellow,
                                                                  textColor:
                                                                      Colors
                                                                          .black,
                                                                  fontSize:
                                                                      15.0);
                                                            }
                                                          },
                                                          child: Icon(Icons
                                                              .done_outline)),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            txtAboutCompany
                                                                    .text =
                                                                txtAboutCompany
                                                                    .text;
                                                            editCompanyAbout =
                                                                false;
                                                          });
                                                        },
                                                        child:
                                                            Icon(Icons.close))
                                                  ],
                                                ),
                                        ),
                                      ),

                                      //Share Msg
                                      // AnimatedSize(
                                      //   duration: Duration(milliseconds: 250),
                                      //   curve: Curves.easeInOut,
                                      //   vsync: this,
                                      //   child: !editShareMsg
                                      //       ? Row(
                                      //           children: <Widget>[
                                      //             Container(
                                      //               width: MediaQuery.of(context)
                                      //                       .size
                                      //                       .width -
                                      //                   80,
                                      //               child: Row(
                                      //                 crossAxisAlignment:
                                      //                     CrossAxisAlignment.center,
                                      //                 children: <Widget>[
                                      //                   Image.asset(
                                      //                       "images/profile/sharemsg24.png"),
                                      //                   Container(
                                      //                     padding: const EdgeInsets.only(
                                      //                         left: 10),
                                      //                     width: MediaQuery.of(context)
                                      //                             .size
                                      //                             .width -
                                      //                         110,
                                      //                     child: Text(
                                      //                         memberdata.ShareMsg != null
                                      //                             ? memberdata.ShareMsg
                                      //                             : "",
                                      //                         style: TextStyle(
                                      //                             color: Colors.grey[600],
                                      //                             fontSize: 15,
                                      //                             fontWeight:
                                      //                                 FontWeight.w600)),
                                      //                   ),
                                      //                 ],
                                      //               ),
                                      //             ),
                                      //             GestureDetector(
                                      //                 onTap: () {
                                      //                   setState(() {
                                      //                     editShareMsg = true;
                                      //                   });
                                      //                 },
                                      //                 child: Icon(Icons.edit))
                                      //           ],
                                      //         )
                                      //       : Row(
                                      //           children: <Widget>[
                                      //             Container(
                                      //               width: MediaQuery.of(context)
                                      //                       .size
                                      //                       .width -
                                      //                   150,
                                      //               //margin: EdgeInsets.only(top: 20),
                                      //               decoration: BoxDecoration(
                                      //                   color: Color.fromRGBO(
                                      //                       255, 255, 255, 0.5),
                                      //                   border: new Border.all(width: 1),
                                      //                   borderRadius: BorderRadius.all(
                                      //                       Radius.circular(5))),
                                      //               child: TextFormField(
                                      //                 controller: txtShareMsg,
                                      //                 maxLines: 3,
                                      //                 decoration: InputDecoration(
                                      //                     prefixIcon: Image.asset(
                                      //                         "images/profile/sharemsg24.png"),
                                      //                     hintText: "Share Msg"),
                                      //                 keyboardType: TextInputType.text,
                                      //                 style:
                                      //                     TextStyle(color: Colors.black),
                                      //               ),
                                      //               //height: 40,
                                      //             ),
                                      //             Padding(
                                      //               padding: const EdgeInsets.symmetric(
                                      //                   horizontal: 20),
                                      //               child: GestureDetector(
                                      //                   onTap: () {
                                      //                     if (txtShareMsg.text != "") {
                                      //                       updateProfile('ShareMsg',
                                      //                               txtShareMsg.text)
                                      //                           .then((val) {
                                      //                         memberdata.ShareMsg =
                                      //                             txtShareMsg.text;
                                      //                         setState(() {
                                      //                           editShareMsg = false;
                                      //                         });
                                      //                       }, onError: (e) {
                                      //                         txtShareMsg.text =
                                      //                             memberdata.ShareMsg;
                                      //                         setState(() {
                                      //                           editShareMsg = false;
                                      //                         });
                                      //                       });
                                      //                     } else {
                                      //                       Fluttertoast.showToast(
                                      //                           msg:
                                      //                               "Please Enter Data First",
                                      //                           toastLength:
                                      //                               Toast.LENGTH_SHORT,
                                      //                           gravity: ToastGravity.TOP,
                                      //                           backgroundColor:
                                      //                               Colors.yellow,
                                      //                           textColor: Colors.black,
                                      //                           fontSize: 15.0);
                                      //                     }
                                      //                   },
                                      //                   child: Icon(Icons.done_outline)),
                                      //             ),
                                      //             GestureDetector(
                                      //                 onTap: () {
                                      //                   txtShareMsg.text =
                                      //                       memberdata.ShareMsg;
                                      //                   setState(() {
                                      //                     editShareMsg = false;
                                      //                   });
                                      //                 },
                                      //                 child: Icon(Icons.close))
                                      //           ],
                                      //         ),
                                      // ),
                                    ],
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.only(top: 10),
                                  height: 48,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(0))),
                                  child: MaterialButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(0.0)),
                                    color: cnst.appMaterialColor,
                                    minWidth: MediaQuery.of(context).size.width,
                                    onPressed: () {
                                      showEventDialog(context);
                                    },
                                    child: Text(
                                      "Upload Brochure",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }

  showEventDialog(BuildContext context1) async {
    showDialog(
        context: context,
        builder: (BuildContext context) => MyDialog((action) {
              if (action == "listref") {
                //get List Code
                // getTestimonialDataFromServer();
                /*Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyAskForum(
                          DashBoardType: "${widget.DashBoardType}",
                        )));*/
              }
            }));
  }

  void _coverImagePopup(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.camera_alt),
                    title: new Text('Camera'),
                    onTap: () async {
                      var image = await ImagePicker.pickImage(
                          source: ImageSource.camera);
                      if (image != null)
                        setState(() {
                          _imageCover = image;
                          _editCoverImg = true;
                        });
                      Navigator.pop(context);
                    }),
                new ListTile(
                    leading: new Icon(Icons.photo),
                    title: new Text('Gallery'),
                    onTap: () async {
                      var image = await ImagePicker.pickImage(
                          source: ImageSource.gallery);
                      if (image != null)
                        setState(() {
                          _imageCover = image;
                          _editCoverImg = true;
                        });
                      Navigator.pop(context);
                    }),
              ],
            ),
          );
        });
  }

  void _profileImagePopup(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.camera_alt),
                    title: new Text('Camera'),
                    onTap: () async {
                      var image = await ImagePicker.pickImage(
                          source: ImageSource.camera);
                      if (image != null)
                        setState(() {
                          _imageProfile = image;
                          _editProfileImg = true;
                        });
                      Navigator.pop(context);
                    }),
                new ListTile(
                    leading: new Icon(Icons.photo),
                    title: new Text('Gallery'),
                    onTap: () async {
                      var image = await ImagePicker.pickImage(
                          source: ImageSource.gallery);
                      if (image != null)
                        setState(() {
                          _imageProfile = image;
                          _editProfileImg = true;
                        });
                      Navigator.pop(context);
                    }),
              ],
            ),
          );
        });
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

class MyDialog extends StatefulWidget {
  //var id, AskId;
  final Function onChange;

  MyDialog(this.onChange);

  @override
  _MyDialogState createState() => new _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  double rating = 0.0;
  TextEditingController edtDesc = new TextEditingController();
  static var now = new DateTime.now();
  var date = new DateFormat("yyyy-MM-dd").format(now);
  bool isLoading = false;
  FileType _pickingType = FileType.any;
  bool _loadingPath = false;
  bool _hasValidMime = false;
  String _fileName;
  String memberid;
  String _path;
  File _imageNotice;
  ProgressDialog pr;

  showMsg(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Close",
                style: TextStyle(color: cnst.appMaterialColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _uploadBrochure() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // pr.show();
        String filename = "";
        String filePath = "";
        File compressedFile;

        if (_imageNotice != null) {
          ImageProperties properties =
              await FlutterNativeImage.getImageProperties(_imageNotice.path);

          compressedFile = await FlutterNativeImage.compressImage(
            _imageNotice.path,
            quality: 80,
            targetWidth: 600,
            targetHeight: (properties.height * 600 / properties.width).round(),
          );

          filename = _imageNotice.path.split('/').last;
          filePath = compressedFile.path;
        } else if (_path != null && _path != '') {
          filePath = _path;
          filename = _fileName;
        }

        FormData formData = new FormData.fromMap({
          "type": "updatebrochure",
          "memberId": memberid,
          "File": (filePath != null && filePath != '')
              ? await MultipartFile.fromFile(filePath,
                  filename: filename.toString())
              : null
        });

        Services.uploadBrochure(formData).then((data) async {
          // pr.hide();
          if (data.MESSAGE != "0") {
            showMsg(data.MESSAGE);
          } else {
            showMsg(data.MESSAGE);
          }
        }, onError: (e) {
          // pr.hide();
          showMsg("Try Again.");
        });
      } else {
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      // pr.hide();

      showMsg("No Internet Connection.");
    }
  }

  @override
  void initState() {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
        message: "Please Wait",
        borderRadius: 10.0,
        progressWidget: Container(
          padding: EdgeInsets.all(15),
          child: CircularProgressIndicator(
            backgroundColor: cnst.appMaterialColor,
          ),
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w600));
    // TODO: implement initState
    super.initState();
    _getLocalData();
  }

  _getLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    memberid = prefs.getString(Session.digital_Id);
  }

  void _openFileExplorer() async {
    if (_pickingType != FileType.custom || _hasValidMime) {
      setState(() => _loadingPath = true);
      try {
        _path = await FilePicker.getFilePath(
          type: _pickingType,
        );
      } on PlatformException catch (e) {
        print("Unsupported operation" + e.toString());
      }
      if (!mounted) return;
      setState(() {
        _loadingPath = false;
        _imageNotice = null;
        //_fileName = _path != null ? _path : '';
        _fileName = _path != null ? _path.split('/').last : '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      //this right here
      child: Container(
        padding: EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 20),
        //width: MediaQuery.of(context).size.width,
        //height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          //mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Upload Brochure",
                  style: TextStyle(
                      color: cnst.appMaterialColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Divider(
              color: Colors.grey[400],
            ),
            Container(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      _openFileExplorer();
                    },
                    color: cnst.appMaterialColor,
                    textColor: Colors.white,
                    shape: StadiumBorder(),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.file_upload,
                          size: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            "Upload \nFile",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  _imageNotice != null
                      ? Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Image.file(
                            File(_imageNotice.path),
                            height: 150,
                            fit: BoxFit.fitHeight,
                          ),
                        )
                      : _fileName != null && _fileName != ''
                          ? Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text(
                                "${_fileName}",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          : Container(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width / 3.3,
                    margin: EdgeInsets.only(top: 10),
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0)),
                      color: cnst.appMaterialColor,
                      minWidth: MediaQuery.of(context).size.width - 10,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 3.3,
                    margin: EdgeInsets.only(top: 10),
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0)),
                      color: cnst.appMaterialColor,
                      minWidth: MediaQuery.of(context).size.width - 10,
                      onPressed: () {
                        _uploadBrochure();
                      },
                      child: Text(
                        "Submit",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 14.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    ;
  }
}
