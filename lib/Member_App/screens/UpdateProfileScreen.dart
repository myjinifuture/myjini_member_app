import 'dart:io';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Mall_App/transitions/slide_route.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;
import 'package:smart_society_new/Member_App/screens/CustomerProfile.dart';
import 'package:smart_society_new/Member_App/screens/MyProfile.dart';

import 'OTP.dart';

class UpdateProfile extends StatefulWidget {
  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final List<String> _dropdownValues = [
    "A+",
    "A-",
    "B+",
    "B-",
    "O+",
    "O-",
    "AB+",
    "AB-"
  ];

  //final List<String> _residentTypeList = ["Rented", "Owner", "Owned"];
  final List<String> _residentTypeList = ["Rented", "Owned"];

  int selected_Index;

  File _image;
  String _fileName;
  String _path;

  String _isSwitched;

  //String SocietyId,Name,Wing,ResidanceType,FlatNo,MobileNumber,BusinessJob,Description,CompanyName,BloodGroup,GenderData;

  TextEditingController SocietyIdtxt = new TextEditingController();
  TextEditingController Nametxt = new TextEditingController();
  TextEditingController Wingtxt = new TextEditingController();
  TextEditingController Residanceypetxt = new TextEditingController();
  TextEditingController MobileNumbertxt = new TextEditingController();
  TextEditingController BusinessJobtxt = new TextEditingController();
  TextEditingController Descriptiontxt = new TextEditingController();
  TextEditingController Addresstxt = new TextEditingController();
  TextEditingController CompanyNametxt = new TextEditingController();

  String MemberId, Profile;

  DateTime _BirthDate;
  String _format = 'yyyy-MMMM-dd';
  DateTimePickerLocale _locale = DateTimePickerLocale.en_us;

  ProgressDialog pr;
  String FlatNo;

  _getLocaldata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      wingId = prefs.getString(constant.Session.WingId);
      MemberId = prefs.getString(constant.Session.Member_Id);
      Profile = prefs.getString(constant.Session.Profile);
      Nametxt.text = prefs.getString(constant.Session.Name);
      Wingtxt.text = prefs.getString(constant.Session.Wing);
      Residanceypetxt.text = prefs.getString(constant.Session.ResidenceType);
      FlatNo = prefs.getString(constant.Session.FlatNo);
      MobileNumbertxt.text = prefs.getString(constant.Session.session_login);
      BusinessJobtxt.text = prefs.getString(constant.Session.Designation);
      Descriptiontxt.text =
          prefs.getString(constant.Session.BusinessDescription);
      CompanyNametxt.text = prefs.getString(constant.Session.CompanyName);
      if (prefs.getString(constant.Session.BloodGroup) != "" &&
          prefs.getString(constant.Session.BloodGroup).toString() != "null")
        Selected_bloodGroup = prefs.getString(constant.Session.BloodGroup);
      Gender = prefs.getString(constant.Session.Gender);
      Addresstxt.text = prefs.getString(constant.Session.Address);
      _isSwitched = prefs.getString(constant.Session.isPrivate);
      if (prefs.getString(constant.Session.DOB) != "" &&
          prefs.getString(constant.Session.DOB) != "null")
        _BirthDate = DateTime.parse(prefs.getString(constant.Session.DOB));

      if (prefs.getString(constant.Session.ResidenceType) == "Rented")
        setState(() {
          selected_Index = 0;
        });
      else if (prefs.getString(constant.Session.ResidenceType) == "Owner")
        setState(() {
          selected_Index = 1;
        });
      else if (prefs.getString(constant.Session.ResidenceType) == "Owned")
        setState(() {
          selected_Index = 2;
        });
    });
  }

  void _showDatePicker() {
    DatePicker.showDatePicker(
      context,
      pickerTheme: DateTimePickerTheme(
        showTitle: true,
        confirm: Text('Done',
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600)),
        cancel: Text('Cancel',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
      ),
      initialDateTime: DateTime.now(),
      dateFormat: _format,
      locale: _locale,
      onChange: (dateTime, List<int> index) {
        setState(() {
          _BirthDate = dateTime;
        });
      },
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          _BirthDate = dateTime;
        });
      },
    );
  }

  @override
  void initState() {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(message: 'Please Wait');
    _getLocaldata();
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
                          source: ImageSource.camera,
                          maxHeight: 200,
                          maxWidth: 200);
                      if (image != null) {
                        setState(() {
                          _image = image;
                        });
                        UpdateProfilePhoto();
                      }
                      Navigator.pop(context);
                    }),
                new ListTile(
                    leading: new Icon(Icons.photo),
                    title: new Text('Gallery'),
                    onTap: () async {
                      var image = await ImagePicker.pickImage(
                          source: ImageSource.gallery,
                          maxHeight: 200,
                          maxWidth: 200);
                      if (image != null) {
                        setState(() {
                          _image = image;
                        });
                        UpdateProfilePhoto();
                      }
                      Navigator.pop(context);
                    }),
              ],
            ),
          );
        });
  }

  UpdateProfilePhoto() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // pr.show();

        String filename = "";
        String filePath = "";
        File compressedFile;

        if (_image != null) {
          ImageProperties properties =
              await FlutterNativeImage.getImageProperties(_image.path);

          compressedFile = await FlutterNativeImage.compressImage(
            _image.path,
            quality: 100,
            targetWidth: 600,
            targetHeight: (properties.height * 600 / properties.width).round(),
          );

          filename = _image.path.split('/').last;
          filePath = compressedFile.path;
        } else if (_path != null && _path != '') {
          filePath = _path;
          filename = _fileName;
        }
        FormData formData = new FormData.fromMap({
          "Id": MemberId,
          "Image": (filePath != null && filePath != '')
              ? await MultipartFile.fromFile(filePath,
                  filename: filename.toString())
              : null,
        });
        print(MemberId);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        Services.UpdateProfilephoto(formData).then((data) async {
          // pr.hide();
          if (data.Data != "0" && data.IsSuccess == true) {
            await prefs.setString(constant.Session.Profile, data.Data);
            showHHMsg("Update Successfully", "");
          } else {
            // pr.hide();
          }
        }, onError: (e) {
          // pr.hide();
          showHHMsg("Try Again.", "");
        });
      } else {
        showHHMsg("No Internet Connection.", "");
      }
    } on SocketException catch (_) {
      // pr.hide();
      showHHMsg("No Internet Connection.", "");
    }
  }

  String Selected_bloodGroup;
  String Gender, wingId;

  _updateProfileImage() async {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          String img = '';
          if (_image != null) {
            List<int> imageBytes = await _image.readAsBytesSync();
            String base64Image = base64Encode(imageBytes);
            img = base64Image;
          }
          var data = {
            "memberId" : MemberId,
            "Image" : img
          };
          Services.responseHandler(apiName: "member/updateMemberProfileImage",body: data).then((data) async {
            // pr.hide();
            if (data.Data.toString() == "1") {
              print("member/updateMemberProfileImage called");
            } else {

            }
          }, onError: (e) {

            showHHMsg("Something Went Wrong", "Error");
          });
        }
      } on SocketException catch (_) {
        showHHMsg("No Internet Connection.", "");
      }
  }

  _UpdateProfile() async {
        try {
          final result = await InternetAddress.lookup('google.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            String filename = "";
            String filePath = "";
            File compressedFile;

            if (_image != null) {
              ImageProperties properties =
              await FlutterNativeImage.getImageProperties(_image.path);

              compressedFile = await FlutterNativeImage.compressImage(
                _image.path,
                quality: 100,
                targetWidth: 600,
                targetHeight: (properties.height * 600 / properties.width).round(),
              );

              filename = _image.path.split('/').last;
              filePath = compressedFile.path;
            } else if (_path != null && _path != '') {
              filePath = _path;
              filename = _fileName;
            }
            FormData formData = new FormData.fromMap({
              "Address": Addresstxt.text,
              "WorkType": "",
              "DateOfRentAggrement": "",
              "CompanyName": CompanyNametxt.text,
              "Designation": BusinessJobtxt.text,
              "DOB": _BirthDate.toString(),
              "BusinessDescription": Descriptiontxt.text,
              "BloodGroup": Selected_bloodGroup,
              "EmailId": "",
              "NoOfFamilyMember": "",
              "Township" : "",
              "OfficeEmail":"",
              "OfficeContact": MobileNumbertxt.text,
              "Name": Nametxt.text,
              "memberId": MemberId,
              "Image": (filePath != null && filePath != '')
                  ? await MultipartFile.fromFile(filePath,
                  filename: filename.toString())
                  : null,
              // "ProfessionId": "",
              // "ParentId": "",
              // "WingId": wingId,
              // "FlatNo": FlatNo,
              // "ResidenceType": _residentTypeList[selected_Index],
              // "Gender": Gender,
              // "IsPrivate": _isSwitched,
              // "FcmToken": "",
              // "IsVerified": true,
              // "Relation": "",
              // "IsActive": true,
              // "Wing": ""
            });
            // pr.show();
            SharedPreferences prefs = await SharedPreferences.getInstance();
            Services.responseHandler(apiName: "member/updateMemberProfile",body: formData).then((data) async {
              // pr.hide();
              if (data.Data != "0" && data.IsSuccess == true) {
                _updateProfileImage();
                await prefs.setString(
                    constant.Session.session_login, MobileNumbertxt.text);
                // await prefs.setString(constant.Session.ResidenceType,
                //     _residentTypeList[selected_Index]);
                await prefs.setString(constant.Session.Name, Nametxt.text);
                await prefs.setString(
                    constant.Session.CompanyName, CompanyNametxt.text);
                await prefs.setString(
                    constant.Session.Designation, BusinessJobtxt.text);
                await prefs.setString(
                    constant.Session.BusinessDescription, Descriptiontxt.text);
                await prefs.setString(
                    constant.Session.BloodGroup, Selected_bloodGroup);
                await prefs.setString(constant.Session.Gender, Gender);
                await prefs.setString(
                    constant.Session.DOB, _BirthDate.toString());
                await prefs.setString(
                    constant.Session.Address, Addresstxt.text);
                await prefs.setString(constant.Session.isPrivate, _isSwitched);
                showHHMsg("Update Successfully", "");
              } else {
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
              child: new Text("OK"),
              onPressed: () {
                // Navigator.pushReplacement(
                //     context, SlideLeftRoute(page: CustomerProfile()));
                Navigator.pushNamedAndRemoveUntil(
                    context, '/HomeScreen', (route) => false);
              },
            ),
          ],
        );
      },
    );
  }

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

    return final_date;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // Navigator.pushAndRemoveUntil(context,
              //     SlideLeftRoute(page: CustomerProfile()), (route) => false);

              Navigator.pushReplacement(
                  context, SlideLeftRoute(page: MyProfileScreen()));
              // Navigator.pushReplacementNamed(context, "/MyProfile");
            }),
        centerTitle: true,
        title: Text(
          'Profile Update',
          style: TextStyle(fontSize: 18),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Container(
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                            image: new DecorationImage(
                                image: _image == null
                                    ? '$Profile' == "null" || '$Profile' == ""
                                        ? AssetImage("images/man.png")
                                        : NetworkImage(
                                            constant.Image_Url + '$Profile')
                                    : FileImage(_image),
                                fit: BoxFit.cover),
                            borderRadius:
                                BorderRadius.all(new Radius.circular(75.0)),
                            boxShadow: [
                              BoxShadow(color: Colors.grey[600], blurRadius: 2)
                            ]),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _profileImagePopup(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 105.0, left: 90),
                        child: Container(
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                              color: constant.appPrimaryMaterialColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100.0))),
                          child: Icon(Icons.add, color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text("Private Your Profile",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700])),
            ),
            Transform.scale(
              scale: 1.2,
              child: Switch(
                onChanged: (val) => setState(
                    () => _isSwitched = val == true ? "true" : "false"),
                value: _isSwitched == "true" ? true : false,
                activeColor: Colors.green,
                activeTrackColor: Colors.green[200],
                inactiveThumbColor: Colors.grey,
                inactiveTrackColor: Colors.grey[400],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TextFormField(
                      controller: Nametxt,
                      // controller: _MobileNumber,
                      decoration: InputDecoration(
                        hintText: "Enter Name",
                        hasFloatingPlaceholder: true,
                        labelText: "Name",
                        hintStyle: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TextFormField(
                      controller: MobileNumbertxt,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "Enter Mobile Number",
                        hasFloatingPlaceholder: true,
                        labelText: "Mobile No",
                        hintStyle: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TextFormField(
                      controller: CompanyNametxt,
                      decoration: InputDecoration(
                        hintText: "Enter Company Name",
                        hasFloatingPlaceholder: true,
                        labelText: "Company Name",
                        hintStyle: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TextFormField(
                      controller: BusinessJobtxt,
                      decoration: InputDecoration(
                        hintText: "Enter Business / Job",
                        hasFloatingPlaceholder: true,
                        labelText: "Job / Business",
                        hintStyle: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TextFormField(
                      controller: Descriptiontxt,
                      // controller: _MobileNumber,
                      decoration: InputDecoration(
                        hintText: "Enter Business / Job Description",
                        hasFloatingPlaceholder: true,
                        labelText: "Job / Business Desscription",
                        hintStyle: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 8.0, top: 12.0),
              child: DropdownButton(
                items: _dropdownValues
                    .map((value) => DropdownMenuItem(
                          child: Text(value),
                          value: value,
                        ))
                    .toList(),
                value: Selected_bloodGroup,
                onChanged: (newValue) {
                  setState(() {
                    Selected_bloodGroup = newValue;
                  });
                },
                isExpanded: true,
                hint: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text('--Select Blood Group --'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TextFormField(
                      maxLines: 3,
                      controller: Addresstxt,
                      // controller: _MobileNumber,
                      decoration: InputDecoration(
                        hintText: "Enter Address",
                        hasFloatingPlaceholder: true,
                        labelText: "Address",
                        hintStyle: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 9.0, top: 10),
                    child: Text("Gender", style: TextStyle(fontSize: 13)),
                  ),
                ],
              ),
            ),
            Row(
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
                Text("Female", style: TextStyle(fontSize: 13)),
              ],
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Wrap(
            //     spacing: 10,
            //     children: List.generate(_residentTypeList.length, (index) {
            //       return ChoiceChip(
            //         backgroundColor: Colors.grey[200],
            //         label: Text(_residentTypeList[index]),
            //         selected: selected_Index == index,
            //         onSelected: (selected) {
            //           if (selected) {
            //             setState(() {
            //               selected_Index = index;
            //               print(_residentTypeList[index]);
            //             });
            //           }
            //         },
            //       );
            //     }),
            //   ),
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, bottom: 4.0),
                  child: Text(
                    "Date Of Birth",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  _showDatePicker();
                },
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          _BirthDate != null && _BirthDate != ""
                              ? setDate(_BirthDate.toString())
                              : "Select Your BirthDate",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 18.0, left: 8, right: 8, bottom: 18.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 45,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  color: constant.appPrimaryMaterialColor[500],
                  textColor: Colors.white,
                  splashColor: Colors.white,
                  child: Text("Update",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  onPressed: () {
                    _UpdateProfile(); // ask monil to make updatememberprofile api 15 number
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => OTP(
                    //         mobileNo: MobileNumbertxt.text.toString(),
                    //         onSuccess: () {
                    //           _UpdateProfile(); // ask monil to make updatememberprofile api 15 number
                    //         },
                    //       ),
                    //     ));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
