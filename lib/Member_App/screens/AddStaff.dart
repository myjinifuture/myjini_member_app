import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Member_App/common/Classlist.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart';
import 'package:smart_society_new/Member_App/component/masktext.dart';

class AddStaff extends StatefulWidget {
  Function onAddStaff;
  AddStaff({this.onAddStaff});
  @override
  _AddStaffState createState() => _AddStaffState();
}

class _AddStaffState extends State<AddStaff> {
  List<staffClass> _staffTypeList = [];
  staffClass _staffClass;
  bool isLoading = false;
  File image;
  ProgressDialog pr;
  int wingflatcount = 0;
  File _image;
  String Gender;

  TextEditingController txtName = TextEditingController();
  TextEditingController txtaddress = TextEditingController();
  TextEditingController txtagencyname = TextEditingController();
  TextEditingController txtContactNo = TextEditingController();
  TextEditingController txtvoterId = TextEditingController();
  TextEditingController txtwingflatcount = TextEditingController();
  TextEditingController vehiclenotext = TextEditingController();
  TextEditingController adharnumbertxt = TextEditingController();
  TextEditingController worktext = TextEditingController();
  TextEditingController purposetext = TextEditingController();
  TextEditingController txtemergencyNo = TextEditingController();

  List wingclasslist = [];
  String SelectType;
  String SocietyId, wingId;
  WingClass wingClass;
  String selectedWing;
  bool _WingLoading = false;
  List FlatData = [];
  List wingData = [];
  List _selectedFlatlist = [];
  StaffType staffType;
  bool _StaffLoading = false;
  bool isForSociety = true;
  List staffDetailslist = [];
  List<String> staffCategoryList = [];
  String staff;

  List finalSelectList = [];
  List allFlatList = [];
  List allWingList = [];

  @override
  void initState() {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(message: 'Please Wait');
    _getLocaldata();
    _WingListData();
    getWingsId();
    staffCategory();
  }

  _getLocaldata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SocietyId = prefs.getString(Session.SocietyId);
    wingId = prefs.getString(Session.WingId);
  }

  List wingsList = [];

  getWingsId() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var body = {"societyId": SocietyId};
        Services.responseHandler(
                apiName: "admin/getAllWingOfSociety", body: body)
            .then((data) async {
          if (data.Data != null) {
            setState(() {
              // wingsList = data.Data;
              for(int i=0;i<data.Data.length;i++){
                if(data.Data[i]["totalFloor"].toString()!="0"){
                  // wingsList.add(data.Data[i]);
                  wingsList.add({
                    "Name" : data.Data[i]["wingName"],
                    "Id" : data.Data[i]["_id"],
                  });
                }
              }
            });
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

  DateTime SelectedDOB = DateTime.now();
  DateTime SelectedDOJ = DateTime.now();

  Future<Null> _selectDOB(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: SelectedDOB,
        firstDate: DateTime(1900, 1),
        lastDate: DateTime(2050));
    if (picked != null && picked != SelectedDOB)
      setState(() {
        SelectedDOB = picked;
      });
  }

  Future<Null> _selectedDOJ(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: SelectedDOJ,
        firstDate: DateTime(1900, 1),
        lastDate: DateTime(2050));
    if (picked != null && picked != SelectedDOJ)
      setState(() {
        SelectedDOJ = picked;
      });
  }

  _WingListData() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var data = {"societyId": SocietyId};
        setState(() {
          _WingLoading = true;
        });
        Services.responseHandler(
                apiName: "admin/getAllWingOfSociety", body: data)
            .then((data) async {
          if (data.Data != null && data.Data.length > 0) {
            setState(() {
              wingclasslist = data.Data;
              _WingLoading = false;
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

  staffCategory() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // setState(() {
        //   isLoading = true;
        // });
        var data={};

        Services.responseHandler(apiName: "admin/getAllStaffCategory",body: data).then(
            (data) async {
          if (data.Data != null && data.Data.length > 0) {
            setState(() {
              print("api called getAllStaffCategory data:");
              print(data.Data);
              staffDetailslist = data.Data;
            });
            for(int i=0;i<staffDetailslist.length;i++){
              staffCategoryList.add(staffDetailslist[i]['staffCategoryName'].toString());
            }
            // setState(() {
            //   isLoading = false;
            // });
          } else {
            setState(() {
              isLoading = false;
            });
          }
        }, onError: (e) {
          // setState(() {
          //   isLoading = false;
          // });
          Fluttertoast.showToast(
              msg: "Something Went Wrong", toastLength: Toast.LENGTH_LONG);
        });
      }
    } on SocketException catch (_) {
      // setState(() {
      //   isLoading = false;
      // });
      Fluttertoast.showToast(
          msg: "No Internet Access", toastLength: Toast.LENGTH_LONG);
    }
  }

  showMsg(String msg, {String title = 'MYJINI'}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(title),
          content: new Text(msg),
          actions: <Widget>[
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

  showHHMsg(String title, String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(title),
          content: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              color: Colors.grey[100],
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

  List selectedWingId = [];
  bool staffAdded = false;

  _SaveStaff() async {
    if (txtName.text != "") {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          String SocietyId = preferences.getString(Session.SocietyId);
          for (int i = 0; i < wingsList.length; i++) {
            for(int j=0;j<selectWing.length;j++) {
              if (selectWing[j] == wingsList[i]["Name"]) {
                selectedWingId.add(wingsList[i]["Id"]);
              }
            }
          }
          print("selected wings sent to backend");
          print(selectedWingId);
          FormData formData = new FormData.fromMap({
            "societyId": SocietyId,
            "Name": txtName.text,
            "ContactNo1": txtContactNo.text,
            "wingId": selectedWingId.toString().replaceAll("]", "").replaceAll("[", "").replaceAll(" ", ""),
            // "flatId" : null,
            // "identityProof" : null,
            "VehicleNo": vehiclenotext.text,
            "DateOfBirth": SelectedDOB.toString(),
            "DateOfJoin": SelectedDOJ.toString(),
            "RecruitType": SelectType,
            "staffImage": image == null ? "" : image,
            "AgencyName": txtagencyname.text,
            "AadharcardNo": adharnumbertxt.text,
            "VoterId": txtvoterId.text,
            "EmergencyContactNo": txtemergencyNo.text,
            "Gender": Gender.toLowerCase(),
            // "VehicleNo": vehiclenotext.text,
            "Address": txtaddress.text,
            "isForSociety":isForSociety,

            // "RoleId": staffType.TypeId,
            "Work": worktext.text,
            "staffCategory": staff,
            "workLocation": []
          });
          print({
            "societyId": SocietyId,
            "Name": txtName.text,
            "ContactNo1": txtContactNo.text,
            "wingId": selectedWingId,
            // "flatId" : null,
            // "identityProof" : null,
            "VehicleNo": vehiclenotext.text,
            "DateOfBirth": SelectedDOB.toString(),
            "DateOfJoin": SelectedDOJ.toString(),
            "RecruitType": SelectType,
            "staffImage": image == null ? "" : image,
            "AgencyName": txtagencyname.text,
            "AadharcardNo": adharnumbertxt.text,
            "VoterId": txtvoterId.text,
            "EmergencyContactNo": txtemergencyNo.text,
            "Gender": Gender.toLowerCase(),
            // "VehicleNo": vehiclenotext.text,
            "Address": txtaddress.text,
            "isForSociety":isForSociety,
            // "RoleId": staffType.TypeId,
            "Work": worktext.text,
            "staffCategory": staff,
          });

          // pr.show();
          Services.responseHandler(apiName: "member/addStaff_v1", body: formData)
              .then((data) async {
            // pr.hide();
            if (data.Data.length > 0 && data.IsSuccess == true) {
              setState(() {
                staffAdded = true;
              });
              print("data.Data");
              print(data.Data);
              Fluttertoast.showToast(
                  msg: "Staff Added Successfully!!!",
                  backgroundColor: Colors.green,
                  gravity: ToastGravity.TOP,
                  textColor: Colors.white);
             Navigator.pop(context);
             widget.onAddStaff();
            } else {
              // pr.hide();
              showMsg(data.Message, title: "MYJINI");
            }
          }, onError: (e) {
            // pr.hide();
            showMsg("Try Again.");
          });
        }
      } on SocketException catch (_) {
        // pr.hide();
        showMsg("No Internet Connection.");
      }
    } else
      Fluttertoast.showToast(
          msg: "Please Fill All Fields",
          backgroundColor: Colors.red,
          gravity: ToastGravity.TOP,
          textColor: Colors.white);
  }



  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  bool buttonPressed = false;
  List selectWing = [];

  @override
  Widget build(BuildContext context) {
    print("staffDetailslist");
    print(staffDetailslist);
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Add Staff",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: isLoading
              ? Container(
                  child: Center(child: CircularProgressIndicator()),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              getImage();
                            },
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  _image == null
                                      ? Container(
                                          width: 120,
                                          height: 120,
                                          decoration: BoxDecoration(
                                              image: new DecorationImage(
                                                  image: AssetImage(
                                                      'images/user.png'),
                                                  fit: BoxFit.cover),
                                              borderRadius: BorderRadius.all(
                                                  new Radius.circular(75.0)),
                                              border: Border.all(
                                                  width: 2.5,
                                                  color: Colors.white)),
                                        )
                                      : Container(
                                          width: 120,
                                          height: 120,
                                          decoration: BoxDecoration(
                                              image: new DecorationImage(
                                                  image: FileImage(_image),
                                                  fit: BoxFit.cover),
                                              borderRadius: BorderRadius.all(
                                                  new Radius.circular(75.0)),
                                              border: Border.all(
                                                  width: 2.5,
                                                  color: Colors.white)),
                                        ),
                                ],
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 4.0, top: 10.0),
                                child: Text(
                                  "Select StaffType",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      border: Border.all(width: 1),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(6.0))),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                      icon: Icon(
                                        Icons.chevron_right,
                                        size: 20,
                                      ),
                                      hint: staffCategoryList.length > 1
                                          ? Text("Select Staff Type",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600))
                                          : Text(
                                              "staff Type Found",
                                              style: TextStyle(fontSize: 14),
                                            ),
                                      value: staff,
                                      onChanged: (val) {
                                        print(val);
                                        setState(() {
                                          staff = val;
                                        });
                                      },
                                      items: staffCategoryList.map((String value) {
                                        return new DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            value,
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        );
                                      }).toList(),
                                    )),
                                  ),
                                ),
                              ),
                              // need to be updated by Yashfind /path-to-project-dir/.gradle -type f -name "*.lock" | while read f; do rm $f; done

                              // (staff=="Watchmen"||staff=="Select Staff Type")?Container():Padding(
                              //   padding:
                              //   const EdgeInsets.only(left: 8.0, top: 10.0),
                              //   child: Text(
                              //     "Select Wing *",
                              //     style: TextStyle(
                              //         fontSize: 12,
                              //         fontWeight: FontWeight.bold),
                              //   ),
                              // ),
                              // (staff=="Watchmen"||staff=="Select Staff Type")?Container():Padding(
                              //   padding: const EdgeInsets.all(8.0),
                              //   child: Container(
                              //     width: MediaQuery.of(context).size.width,
                              //     decoration: BoxDecoration(
                              //         border: Border.all(width: 1),
                              //         borderRadius: BorderRadius.all(
                              //             Radius.circular(6.0))),
                              //     child: Padding(
                              //       padding: const EdgeInsets.only(left: 4.0),
                              //       child: DropdownButtonHideUnderline(
                              //           child: DropdownButton<dynamic>(
                              //             icon: Icon(
                              //               Icons.chevron_right,
                              //               size: 20,
                              //             ),
                              //             hint: wingsList.length > 0
                              //                 ? Text("Select Wing",
                              //                 style: TextStyle(
                              //                     fontSize: 14,
                              //                     fontWeight: FontWeight.w600))
                              //                 : Text(
                              //               "Wing Not Found",
                              //               style: TextStyle(fontSize: 14),
                              //             ),
                              //             value: selectedWing,
                              //             onChanged: (val) {
                              //               print(val);
                              //               setState(() {
                              //                 selectedWing = val;
                              //                 _selectedFlatlist.clear();
                              //                 FlatData.clear();
                              //               });
                              //               // GetFlatData(val.WingId);
                              //             },
                              //             items: wingsList.map((dynamic val) {
                              //               return new DropdownMenuItem<dynamic>(
                              //                 value: val["wingName"],
                              //                 child: Text(
                              //                   val["wingName"],
                              //                   style:
                              //                   TextStyle(color: Colors.black),
                              //                 ),
                              //               );
                              //             }).toList(),
                              //           )),
                              //     ),
                              //   ),
                              // ),
                              // (staff=="Watchmen"||staff=="Select Staff Type")?MultiSelectDialogField(
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
                              // ):Container(),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: SizedBox(
                              height: 50,
                              child: TextFormField(
                                controller: txtName,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(5.0),
                                      borderSide: new BorderSide(),
                                    ),
                                    labelText: "Staff Name *",
                                    hasFloatingPlaceholder: true,
                                    labelStyle: TextStyle(fontSize: 13)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: SizedBox(
                              height: 50,
                              child: TextFormField(
                                controller: txtContactNo,
                                keyboardType: TextInputType.phone,
                                maxLength: 10,
                                decoration: InputDecoration(
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(5.0),
                                      borderSide: new BorderSide(),
                                    ),
                                    counterText: "",
                                    labelText: "Contact Number *",
                                    hasFloatingPlaceholder: true,
                                    labelStyle: TextStyle(fontSize: 13)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: SizedBox(
                              height: 50,
                              child: TextFormField(
                                controller: txtemergencyNo,
                                keyboardType: TextInputType.phone,
                                maxLength: 10,
                                decoration: InputDecoration(
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(5.0),
                                      borderSide: new BorderSide(),
                                    ),
                                    counterText: "",
                                    labelText: "Emergency Contact Number",
                                    hasFloatingPlaceholder: true,
                                    labelStyle: TextStyle(fontSize: 13)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: SizedBox(
                              height: 50,
                              child: TextFormField(
                                inputFormatters: [
                                  MaskedTextInputFormatter(
                                    mask: 'xx-xx-xx-xxxx',
                                    separator: '-',
                                  ),
                                ],
                                controller: vehiclenotext,
                                keyboardType: TextInputType.text,
                                textCapitalization:
                                    TextCapitalization.characters,
                                decoration: InputDecoration(
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(5.0),
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
                            padding: const EdgeInsets.only(top: 10.0),
                            child: SizedBox(
                              height: 50,
                              child: TextFormField(
                                controller: worktext,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(5.0),
                                      borderSide: new BorderSide(),
                                    ),
                                    counterText: "",
                                    labelText: "Enter Work",
                                    hasFloatingPlaceholder: true,
                                    labelStyle: TextStyle(fontSize: 13)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: SizedBox(
                              height: 50,
                              child: TextFormField(
                                controller: txtaddress,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(5.0),
                                      borderSide: new BorderSide(),
                                    ),
                                    labelText: "Staff Address",
                                    hasFloatingPlaceholder: true,
                                    labelStyle: TextStyle(fontSize: 13)),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 4.0, top: 6.0),
                                child: Text(
                                  "Gender *",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black),
                                ),
                              ),
                            ],
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
                          Row(
                            children: <Widget>[
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(top: 12.0),
                                      child: Text(
                                        "Select DOB",
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        _selectDOB(context);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10.0, right: 4.0),
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 45,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 1,
                                                  color: Colors.black54),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0))),
                                          child: Center(
                                            child: Text(
                                              '${SelectedDOB.toLocal()}'
                                                  .split(' ')[0],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 12.0, right: 2),
                                      child: Text(
                                        "Select Date Of Join",
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        _selectedDOJ(context);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          top: 10.0,
                                        ),
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 45,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 1,
                                                  color: Colors.black54),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0))),
                                          child: Center(
                                            child: Text(
                                              '${SelectedDOJ.toLocal()}'
                                                  .split(' ')[0],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 4.0, top: 6.0),
                                child: Text(
                                  "RecruitType",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Radio(
                                  value: 'Through Agency',
                                  groupValue: SelectType,
                                  onChanged: (value) {
                                    setState(() {
                                      SelectType = value;
                                      print(SelectType);
                                    });
                                  }),
                              Text("Through Agency",
                                  style: TextStyle(fontSize: 13)),
                              Radio(
                                  value: 'Through Society',
                                  groupValue: SelectType,
                                  onChanged: (value) {
                                    setState(() {
                                      SelectType = value;
                                      print(SelectType);
                                    });
                                  }),
                              Text("Through Society",
                                  style: TextStyle(fontSize: 13)),
                            ],
                          ),
                          SelectType == 'Through Agency'
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      top: 4.0, left: 4.0, right: 4.0),
                                  child: SizedBox(
                                    height: 50,
                                    child: TextFormField(
                                      controller: txtagencyname,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                          border: new OutlineInputBorder(
                                            borderRadius:
                                                new BorderRadius.circular(5.0),
                                            borderSide: new BorderSide(),
                                          ),
                                          labelText: "Agency Name",
                                          hasFloatingPlaceholder: true,
                                          labelStyle: TextStyle(fontSize: 13)),
                                    ),
                                  ),
                                )
                              : Container(),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10.0, right: 4.0, left: 4.0),
                            child: SizedBox(
                              height: 50,
                              child: TextFormField(
                                inputFormatters: [
                                  MaskedTextInputFormatter(
                                    mask: 'xxxx-xxxx-xxxx-xxxx',
                                    separator: '-',
                                  ),
                                ],
                                controller: adharnumbertxt,
                                keyboardType: TextInputType.number,
                                textCapitalization:
                                    TextCapitalization.characters,
                                decoration: InputDecoration(
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(5.0),
                                      borderSide: new BorderSide(),
                                    ),
                                    counterText: "",
                                    labelText: "Enter Adhar No Number",
                                    hintText: "xxxx-xxxx-xxxx-xxxx",
                                    hasFloatingPlaceholder: true,
                                    labelStyle: TextStyle(fontSize: 13)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: SizedBox(
                              height: 50,
                              child: TextFormField(
                                controller: txtvoterId,
                                keyboardType: TextInputType.text,
                                maxLength: 10,
                                decoration: InputDecoration(
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(5.0),
                                      borderSide: new BorderSide(),
                                    ),
                                    counterText: "",
                                    labelText: "Voter Id",
                                    hasFloatingPlaceholder: true,
                                    labelStyle: TextStyle(fontSize: 13)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: MultiSelectFormField(
                              autovalidate: false,
                              title: Text('Select Wing'),
                              validator: (value) {
                                if (value == null || value.length == 0) {
                                  return 'Please select one or more options';
                                }
                              },
                              dataSource: wingsList,
                              textField: 'Name',
                              valueField: 'Name',
                              okButtonLabel: 'OK',
                              cancelButtonLabel: 'CANCEL',
                              hintWidget: selectWing.length == 0 ? Text(
                                  'No Wing Selected'):Text(selectWing.toString()),
                              change: () => selectWing,
                              onSaved: (value) {
                                setState(() {
                                  selectWing = value;
                                });
                                print("selectWing");
                                print(selectWing);
                              },
                            ),
                          ),
                          // Column(
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: <Widget>[
                          //     Padding(
                          //       padding:
                          //           const EdgeInsets.only(left: 8.0, top: 10.0),
                          //       child: Text(
                          //         "Select Wing *",
                          //         style: TextStyle(
                          //             fontSize: 12,
                          //             fontWeight: FontWeight.bold),
                          //       ),
                          //     ),
                          //     Padding(
                          //       padding: const EdgeInsets.all(8.0),
                          //       child: Container(
                          //         width: MediaQuery.of(context).size.width,
                          //         decoration: BoxDecoration(
                          //             border: Border.all(width: 1),
                          //             borderRadius: BorderRadius.all(
                          //                 Radius.circular(6.0))),
                          //         child: Padding(
                          //           padding: const EdgeInsets.only(left: 4.0),
                          //           child: DropdownButtonHideUnderline(
                          //               child: DropdownButton<dynamic>(
                          //             icon: Icon(
                          //               Icons.chevron_right,
                          //               size: 20,
                          //             ),
                          //             hint: wingsList.length > 0
                          //                 ? Text("Select Wing",
                          //                     style: TextStyle(
                          //                         fontSize: 14,
                          //                         fontWeight: FontWeight.w600))
                          //                 : Text(
                          //                     "Wing Not Found",
                          //                     style: TextStyle(fontSize: 14),
                          //                   ),
                          //             value: selectedWing,
                          //             onChanged: (val) {
                          //               print(val);
                          //               setState(() {
                          //                 selectedWing = val;
                          //                 _selectedFlatlist.clear();
                          //                 FlatData.clear();
                          //               });
                          //               // GetFlatData(val.WingId);
                          //             },
                          //             items: wingsList.map((dynamic val) {
                          //               return new DropdownMenuItem<dynamic>(
                          //                 value: val["wingName"],
                          //                 child: Text(
                          //                   val["wingName"],
                          //                   style:
                          //                       TextStyle(color: Colors.black),
                          //                 ),
                          //               );
                          //             }).toList(),
                          //           )),
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          /*    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.4,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: SizedBox(
                              child: MultiSelectFormField(
                                autovalidate: false,
                                title: Text("Select Flat"),
                                dataSource: FlatData,
                                textField: "FlatNo",
                                valueField: 'FlatNo',
                                okButtonLabel: 'OK',
                                cancelButtonLabel: 'CANCEL',
                                hintWidget: Text("Select Flat"),
                                change: () => _selectedFlatlist,
                                onSaved: (value) {
                                  setState(() {
                                    setState(() {
                                      _selectedFlatlist = value;
                                    });
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: RaisedButton(
                              child: Text(
                                "+",
                                style: TextStyle(
                                    fontSize: 24, color: Colors.white),
                              ),
                              onPressed: () {
                                if (!allWingList.contains(wingClass)) {
                                  for (int i = 0;
                                  i < _selectedFlatlist.length;
                                  i++) {
                                    finalSelectList.add({
                                      "WingId": wingClass.WingId,
                                      "FlatId": _selectedFlatlist[i]
                                    });
                                  }
                                  setState(() {
                                    allFlatList.add(_selectedFlatlist);
                                    allWingList.add(wingClass);
                                  });
                                  setState(() {
                                    _selectedFlatlist = [];
                                    wingClass = null;
                                  });
                                } else {
                                  int index =
                                  allWingList.indexOf(wingClass);
                                  print(index);
                                  setState(() {
                                    allWingList.removeAt(index);
                                    allFlatList.removeAt(index);
                                  });
                                  for (int i = 0;
                                  i < _selectedFlatlist.length;
                                  i++) {
                                    finalSelectList.add({
                                      "WingId": wingClass.WingId,
                                      "FlatId": _selectedFlatlist[i]
                                    });
                                  }
                                  setState(() {
                                    allFlatList.add(_selectedFlatlist);
                                    allWingList.add(wingClass);
                                  });
                                  setState(() {
                                    _selectedFlatlist = [];
                                    wingClass = null;
                                  });
                                }
                              }),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Selected Wing & Flat"),
                    ),*/
/*
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: allWingList.length * 60.0,
                        child: ListView.separated(
                          itemCount: allWingList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      allWingList[index].WingName +
                                          '-' +
                                          allFlatList[index]
                                              .toString()
                                              .replaceAll("[", "")
                                              .replaceAll("]", ""),
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder:
                              (BuildContext context, int index) {
                            return Divider();
                          },
                        ),
                      ),
                    ),
*/
                        ],
                      ),
                    ),
                  ],
                ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(4.0),
          child: SizedBox(
            height: 45,
            child: MaterialButton(
              color: appPrimaryMaterialColor,
              minWidth: MediaQuery.of(context).size.width - 20,
              onPressed: !buttonPressed
                  ? () {
                if(staff==''||txtName.text==''||txtContactNo.text==''||Gender=='' || selectWing.length==0){
                  Fluttertoast.showToast(
                      msg: "Please Fill All Mandatory Details",
                      backgroundColor: Colors.red,
                      gravity: ToastGravity.TOP,
                      textColor: Colors.white);
                }
                else{
                  setState(() {
                    if(staffAdded) {
                      buttonPressed = true;
                    }
                  });
                  _SaveStaff();
                }
                    }
                  : null,
              child: Text(
                "Add Staff",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 17.0,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/*
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Member_App/common/Classlist.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart';
import '../common/constant.dart' as constant;

class AddStaff extends StatefulWidget {
  @override
  _AddStaffState createState() => _AddStaffState();
}

class _AddStaffState extends State<AddStaff> {
  List<staffClass> _staffTypeList = [];
  staffClass _staffClass;
  bool isLoading = false;
  File image;
  ProgressDialog pr;
  int wingflatcount = 0;
  File _image;
  String Gender;

  TextEditingController txtName = TextEditingController();
  TextEditingController txtaddress = TextEditingController();
  TextEditingController txtagencyname = TextEditingController();
  TextEditingController txtContactNo = TextEditingController();
  TextEditingController txtvoterId = TextEditingController();
  TextEditingController txtwingflatcount = TextEditingController();
  TextEditingController vehiclenotext = TextEditingController();
  TextEditingController adharnumbertxt = TextEditingController();
  TextEditingController worktext = TextEditingController();
  TextEditingController purposetext = TextEditingController();
  TextEditingController txtemergencyNo = TextEditingController();
  TextEditingController txtusername = TextEditingController();
  TextEditingController txtpassword = TextEditingController();

  List<WingClass> wingclasslist = [];
  String SelectType;
  String SocietyId,fcmToken;
  WingClass wingClass;
  bool _WingLoading = false;
  List FlatData = [];
  List _selectedFlatlist = [];
  StaffType staffType;
  bool _StaffLoading = false;
  List<StaffType> stafftypelist = [];

  List finalSelectList = [];
  List allFlatList = [];
  List allWingList = [];

  @override
  void initState() {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(message: 'Please Wait');
    _StaffType();
    _getLocaldata();
    _WingListData();
  }

  _getLocaldata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SocietyId = prefs.getString(constant.Session.SocietyId);
  }

  DateTime SelectedDOB = DateTime.now();
  DateTime SelectedDOJ = DateTime.now();

  Future<Null> _selectDOB(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: SelectedDOB,
        firstDate: DateTime(1900, 1),
        lastDate: DateTime(2050));
    if (picked != null && picked != SelectedDOB)
      setState(() {
        SelectedDOB = picked;
      });
  }

  Future<Null> _selectedDOJ(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: SelectedDOJ,
        firstDate: DateTime(1900, 1),
        lastDate: DateTime(2050));
    if (picked != null && picked != SelectedDOJ)
      setState(() {
        SelectedDOJ = picked;
      });
  }

  _WingListData() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.GetWinglistData(SocietyId);
        setState(() {
          _WingLoading = true;
        });
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              _WingLoading = false;
              wingclasslist = data;
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

  _StaffType() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.getRoleType();
        setState(() {
          _StaffLoading = true;
        });
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              _StaffLoading = false;
              stafftypelist = data;
            });
          } else {
            setState(() {
              _StaffLoading = false;
            });
          }
        }, onError: (e) {
          setState(() {
            _StaffLoading = false;
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

  showMsg(String msg, {String title = 'MYJINI'}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(title),
          content: new Text(msg),
          actions: <Widget>[
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

  GetFlatData(String WingId) async {
    try {
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          // pr.show();
        });

        Services.getFlatData(WingId).then((data) async {
          setState(() {
            // pr.hide();
          });
          if (data != null && data.length > 0) {
            setState(() {
              FlatData = data;
            });
            print("----->" + data.toString());
          } else {
            setState(() {
              // pr.hide();
            });
          }
        }, onError: (e) {
          setState(() {
            // pr.hide();
          });
          showHHMsg("Try Again.", "");
        });
      } else {
        setState(() {
          // pr.hide();
        });
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
            // usually buttons at the bottom of the dialog
            new FlatButton(
              color: Colors.grey[100],
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

  _SaveStaff(
      String societyId,
      String memberName,
      String mobileNo,
      String username,
      String password,
      String fcmToken,
      String roleId) async {
    if (txtusername.text != "" && txtpassword.text != null) {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          // pr.show();
          Services.AddStaff(
              societyId,
              memberName,
              mobileNo,
              username,
              password,
              fcmToken,
              roleId).then((data) async {
            // pr.hide();
            if (data.Data != "0" && data.IsSuccess == true) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/Dashboard', (Route<dynamic> route) => false);
            } else {
              // pr.hide();
              showMsg(data.Message, title: "Error");
            }
          }, onError: (e) {
            // pr.hide();
            showMsg("Try Again.");
          });
        }
      } on SocketException catch (_) {
        // pr.hide();
        showMsg("No Internet Connection.");
      }
    } else
      Fluttertoast.showToast(
          msg: "Please Fill All Fields",
          backgroundColor: Colors.red,
          gravity: ToastGravity.TOP,
          textColor: Colors.white);
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  saveDeviceToken() async {
    _firebaseMessaging.getToken().then((String token) {
      print("Original Token:$token");
      var tokendata = token.split(':');
      setState(() {
        fcmToken = token;
      });
      print("FCM Token : $fcmToken");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Add Staff",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: isLoading
            ? Container(
          child: Center(child: CircularProgressIndicator()),
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      getImage();
                    },
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _image == null
                              ? Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                                image: new DecorationImage(
                                    image: AssetImage(
                                        'images/user.png'),
                                    fit: BoxFit.cover),
                                borderRadius: BorderRadius.all(
                                    new Radius.circular(75.0)),
                                border: Border.all(
                                    width: 2.5,
                                    color: Colors.white)),
                          )
                              : Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                                image: new DecorationImage(
                                    image: FileImage(_image),
                                    fit: BoxFit.cover),
                                borderRadius: BorderRadius.all(
                                    new Radius.circular(75.0)),
                                border: Border.all(
                                    width: 2.5,
                                    color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding:
                        const EdgeInsets.only(left: 4.0, top: 10.0),
                        child: Text(
                          "Select StaffType",
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              border: Border.all(width: 1),
                              borderRadius:
                              BorderRadius.all(Radius.circular(6.0))),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: DropdownButtonHideUnderline(
                                child: DropdownButton<StaffType>(
                                  icon: Icon(
                                    Icons.chevron_right,
                                    size: 20,
                                  ),
                                  hint: stafftypelist.length > 0
                                      ? Text("Select Staff Type",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600))
                                      : Text(
                                    "staff Type Not Found",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  value: staffType,
                                  onChanged: (val) {
                                    print(val.TypeName);
                                    setState(() {
                                      staffType = val;
                                    });
                                  },
                                  items: stafftypelist
                                      .map((StaffType stafftype) {
                                    return new DropdownMenuItem<StaffType>(
                                      value: stafftype,
                                      child: Text(
                                        stafftype.TypeName,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    );
                                  }).toList(),
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: SizedBox(
                      height: 50,
                      child: TextFormField(
                        controller: txtName,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            border: new OutlineInputBorder(
                              borderRadius:
                              new BorderRadius.circular(5.0),
                              borderSide: new BorderSide(),
                            ),
                            labelText: "Staff Name",
                            hasFloatingPlaceholder: true,
                            labelStyle: TextStyle(fontSize: 13)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: SizedBox(
                      height: 50,
                      child: TextFormField(
                        controller: txtContactNo,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        decoration: InputDecoration(
                            border: new OutlineInputBorder(
                              borderRadius:
                              new BorderRadius.circular(5.0),
                              borderSide: new BorderSide(),
                            ),
                            counterText: "",
                            labelText: "Contact Number",
                            hasFloatingPlaceholder: true,
                            labelStyle: TextStyle(fontSize: 13)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: SizedBox(
                      height: 50,
                      child: TextFormField(
                        controller: txtusername,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            border: new OutlineInputBorder(
                              borderRadius:
                              new BorderRadius.circular(5.0),
                              borderSide: new BorderSide(),
                            ),
                            labelText: "User Name",
                            hasFloatingPlaceholder: true,
                            labelStyle: TextStyle(fontSize: 13)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: SizedBox(
                      height: 50,
                      child: TextFormField(
                        controller: txtpassword,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            border: new OutlineInputBorder(
                              borderRadius:
                              new BorderRadius.circular(5.0),
                              borderSide: new BorderSide(),
                            ),
                            labelText: "Password",
                            hasFloatingPlaceholder: true,
                            labelStyle: TextStyle(fontSize: 13)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(4.0),
        child: SizedBox(
          height: 45,
          child: MaterialButton(
            color: constant.appPrimaryMaterialColor,
            minWidth: MediaQuery.of(context).size.width - 20,
            onPressed: () {
              if(txtName.text=="" || txtContactNo.text.length!=10 || txtusername.text=="" || txtpassword.text==""){
                Fluttertoast.showToast(
                    msg: "Please fill all the fields",
                    backgroundColor: Colors.red,
                    gravity: ToastGravity.BOTTOM,
                    textColor: Colors.white);
              }
              else{
                _SaveStaff(
                    SocietyId,
                    txtName.text,
                    txtContactNo.text,
                    txtusername.text,
                    txtpassword.text,
                    fcmToken,staffType.TypeId,
                );
              }
            },
            child: Text(
              "Add Staff",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}
*/
