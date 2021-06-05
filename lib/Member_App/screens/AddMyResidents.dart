import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Admin_App/Screens/Dashboard.dart';
import 'package:smart_society_new/Mall_App/Common/Colors.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;
// import 'package:smart_society_new/Member_App/common/constant.dart';

class AddMyResidents extends StatefulWidget {
  Function onAddMyResidents;
  String mobileNo;
  bool isUpdate=false;
  AddMyResidents({this.onAddMyResidents,this.mobileNo,this.isUpdate});
  @override
  _AddMyResidentsState createState() => _AddMyResidentsState();
}

class _AddMyResidentsState extends State<AddMyResidents> {
  String stataName, cityName, societyName, buildingName,memberId;
  String flatHolder;
  TextEditingController txtFloorNo = TextEditingController();
  TextEditingController txtFlatNo = TextEditingController();
  List stateData = [];
  String stateId;
  String SocietyId = "";
  List cityData = [];
  String cityId;
  List societyData = [];
  String societyId;
  List wingData = [],memberDetails = [];
  List<String> societies = [];
  String wingId;
  List flatData = [];
  List<String> wings = [];
  List<String> flats = [];
  String flatId;
  List<String> states = [], cities = [],flatholdertypes = [];
  String selState = 'Select your State',
      selCity = 'Select your City',
      selSociety = 'Select your Society',
      selWing = 'Select your Building',
      selFlat = 'Select your Flat Number',
      selFlatHolderType = 'Select flat type';
  bool isLoading = false;
  String selectedStateCode,selectedCountryCode;

  String selectedWingId,selectedFlatId;
  String residenceType;

  @override
  void initState() {
    // getStateList();
    getState();
    flatholdertypes.clear();
    print("widget.isUpdate");
    print(widget.isUpdate);
    widget.isUpdate == null ? null:_showDialog();
    getFlatType();
    // getSocietyList();
    // getSocietyWingList();
    getLocalData();
  }

  getLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      SocietyId = prefs.getString(constant.Session.SocietyId);
      memberId = prefs.getString(constant.Session.Member_Id);
    });
    getAllSocieties();
  }

  List winglistClassList = [];
  String selectedWing,selectedFlat;

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

  TextEditingController txtSocietyId = new TextEditingController();

  _showDialog() async {
    await Future.delayed(Duration(milliseconds: 50));
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: new Text("MYJINI"),
            content:  TextField(
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter your society code',
              ),
              keyboardType: TextInputType.number,
              onEditingComplete: (){
                if(txtSocietyId.text==""){
                  Fluttertoast.showToast(
                      msg: "Please enter society code",
                      backgroundColor: Colors.green,
                      gravity: ToastGravity.TOP,
                      textColor: Colors.white);
                }
                else{
                  // getSocietyDetails(txtSocietyId.text);
                }
              },
              controller: txtSocietyId,
            ),
          ),
        );
      },
    );
  }


  getStateList() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });

        var body = {
          "countryCode" : "IN"
        };
        Services.responseHandler(apiName: "admin/getState",body: body).then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data.Data != null && data.Data.length > 0) {
            setState(() {
              stateData = data.Data;
              for (int i = 0; i < stateData.length; i++) {
                states.add(stateData[i]['name']);
                states.sort();
              }
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

  List wingList = [],flatList = [];
String selectedSocietyId = "";
  _CodeVerification(String code) async {
    try {

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
          wingList.clear();
          if (data.IsSuccess == true && data.Data.length > 0) {
            setState(() {
              selectedSocietyId = data.Data["Society"][0]["_id"];
              for(int i=0;i<data.Data["Wings"].length;i++){
                wingList.add(data.Data["Wings"][i]);
              }
            });
            print("wingList");
            print(wingList);
          } else {
            // setState(() {
            //   valid = false;
            // });
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

  List list = [];

  addMemberDetails() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        String name, mobile;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        name = prefs.getString(constant.Session.Name);
        mobile = prefs.getString(constant.Session.session_login);
        for(int i=0;i<flatList.length;i++){
          if(selFlat == flatList[i]["flatNo"]){
            selectedFlatId = flatList[i]["flatId"];
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
        var data = {
          "memberId": memberId,
          "societyId":selectedSocietyId,
          "wingId": selectedWingId,
          "flatId": selectedFlatId,
          "residenceType": residenceType
        };
        print("data");
        print(data);
        Services.responseHandler(apiName: "member/joinToSociety",body: data)
            .then((data) async {
          setState(() {
            isLoading = false;
          });
          print("data.Data");
          print(data.Data);
          if (data.Data.toString() == "1") {
            // showHHMsg("Data Updated Successfully", "");
            Fluttertoast.showToast(
                msg: "Details Added Successfully!!!",
                toastLength: Toast.LENGTH_LONG,
                textColor: Colors.white,
                gravity: ToastGravity.TOP,
                backgroundColor: Colors.green);
            // Navigator.pushReplacementNamed(context, "/ProfileDetail");
            Navigator.pop(context);
            widget.onAddMyResidents();
          } else {
            Fluttertoast.showToast(
                msg: "Details Already Exists!!!",
                toastLength: Toast.LENGTH_LONG,
                textColor: Colors.white,
                gravity: ToastGravity.TOP,
                backgroundColor: Colors.red);
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

  List logindata=[];

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
                Navigator.of(context).pop();;
                widget.onAddMyResidents();
              },
            ),
          ],
        );
      },
    );
  }

  // showMsg(String msg) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       // return object of type Dialog
  //       return AlertDialog(
  //         title: new Text("Error"),
  //         content: new Text(msg),
  //         actions: <Widget>[
  //           // usually buttons at the bottom of the dialog
  //           new FlatButton(
  //             child: new Text("Okay"),
  //             onPressed: () {
  //               Navigator.of(context).pop();;
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  List<DropdownMenuItem> allSocieties = [];
  String selYourSociety ;

  getAllSocieties() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var data = {
          // "IsVerify" : true,
        };
        setState(() {
          isLoading = true;
        });
        Services.responseHandler(apiName: "masterAdmin/getSocietyList",body: data).then((data) async {
          print(data.Data);
          if (data.Data.length > 0) {
            setState(() {
              for(int i=0;i<data.Data.length;i++){
                allSocieties.add(DropdownMenuItem(
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
                ));
                // allSocieties.add(data.Data[i]["Address"]);
              }
              isLoading = false;
              societyData = data.Data;
            });
            getFlatType();
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

  getFlats(String selectedSocietyId,String wingId) async {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          // pr.show();
          var data = {
            "societyId" : selectedSocietyId,
            "wingId" : wingId
          };
          Services.responseHandler(apiName: "admin/getFlatsOfSociety",body: data).then((data) async {
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
              flatList.clear();
              setState(() {
                for(int i=0;i<data.Data.length;i++){
                  if(!flatList.contains(data.Data[i])) {
                    flatList.add({
                      "flatNo" : data.Data[i]["flatNo"],
                      "flatId" : data.Data[i]["_id"]
                    });
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

  List<DropdownMenuItem> stateClassList = [];
  String selectedState;
  bool buttonPressed = false;

  List allStates = [];
  getState() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var body = {
          "countryCode" : "IN"
        };
        Services.responseHandler(apiName: "admin/getState",body: body).then((data) async {
          if (data.Data != null && data.Data.length > 0) {
            print(stateClassList.runtimeType);
            setState(() {
              for(int i=0;i<data.Data.length;i++){
                if(!stateClassList.contains(DropdownMenuItem(
                  child: Column(
                    children: [
                      Text(data.Data[i]["name"]),
                      Padding(
                        padding: const EdgeInsets.only(top:12.0),
                        child: Container(
                          color: Colors.black,
                          height: 0.5,
                        ),
                      ),
                    ],
                  ),
                  value: data.Data[i]["name"],
                ))) {
                  stateClassList.add(DropdownMenuItem(
                    child: Column(
                      children: [
                        Text(data.Data[i]["name"]),
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Container(
                            color: Colors.black,
                            height: 0.5,
                          ),
                        ),
                      ],
                    ),
                    value: data.Data[i]["name"],
                  ));
                }
                // allSocieties.add(data.Data[i]["Address"]);
              }
              allStates = data.Data;
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

  List<DropdownMenuItem> cityClassList = [];
  List allCities = [];
  String selectedCity;

  getCity(String stateCode,String countryCode) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var body = {
          "countryCode" : countryCode,
          "stateCode" : stateCode
        };
        Services.responseHandler(apiName: "admin/getCity",body: body).then((data) async {
          // pr.hide();
          if (data.Data != null && data.Data.length > 0) {
            setState(() {
              for(int i=0;i<data.Data.length;i++){
                cityClassList.add(DropdownMenuItem(
                  child: Column(
                    children: [
                      Text(data.Data[i]["name"]),
                      Padding(
                        padding: const EdgeInsets.only(top:12.0),
                        child: Container(
                          color: Colors.black,
                          height: 0.5,
                        ),
                      ),
                    ],
                  ),
                  value: data.Data[i]["name"],
                ));
                // allSocieties.add(data.Data[i]["Address"]);
              }
              allCities = data.Data;
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
            child: Icon(Icons.arrow_back),
          ),
        ),
        title: Text(
          'Add Flat/Villa',
          style: TextStyle(fontSize: 18),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(13.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Padding(
              //   padding: const EdgeInsets.only(top: 10.0, bottom: 8),
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text(
              //         "Select State",
              //         style: TextStyle(
              //             fontSize: 15, fontWeight: FontWeight.w600),
              //       ),
              //       // Padding(
              //       //   padding: const EdgeInsets.only(top: 10.0),
              //       //   child: GestureDetector(
              //       //     onTap: () async {
              //       //       await _showStateDialog(context);
              //       //     },
              //       //     child: Container(
              //       //       width: MediaQuery.of(context).size.width,
              //       //       height: 50,
              //       //       decoration: BoxDecoration(
              //       //         border: Border.all(
              //       //           color: Colors.grey,
              //       //           // width: 2,
              //       //         ),
              //       //         borderRadius: BorderRadius.circular(5),
              //       //       ),
              //       //       child: Row(
              //       //         children: [
              //       //           Expanded(
              //       //               child: Padding(
              //       //             padding: const EdgeInsets.only(left: 8.0),
              //       //             child: Text(
              //       //               stataName == "" || stataName == null
              //       //                   ? "Select State "
              //       //                   : stataName,
              //       //               style: TextStyle(fontSize: 18),
              //       //             ),
              //       //           )),
              //       //           Padding(
              //       //             padding: const EdgeInsets.only(right: 8.0),
              //       //             child: Icon(
              //       //               Icons.arrow_drop_down,
              //       //               size: 30,
              //       //             ),
              //       //           )
              //       //         ],
              //       //       ),
              //       //     ),
              //       //   ),
              //       // )
              //       Container(
              //         width: MediaQuery.of(context).size.width,
              //         decoration: BoxDecoration(
              //           border: Border.all(color: Colors.grey),
              //           borderRadius: BorderRadius.circular(5),
              //         ),
              //         child: DropdownButtonHideUnderline(
              //           child: Padding(
              //             padding: const EdgeInsets.only(left: 8.0),
              //             child: DropdownButton<String>(
              //               icon: Icon(
              //                 Icons.arrow_drop_down,
              //                 size: 30,
              //               ),
              //               //isDense: true,
              //               hint: new Text(selState),
              //               // value: _memberClass,
              //               onChanged: (val) {
              //                 print(val);
              //                 cities = [];
              //                 for (int i = 0; i < stateData.length; i++) {
              //                   if (stateData[i]["name"] == val.toString()) {
              //                     selectedStateCode = stateData[i]["isoCode"];
              //                     selectedCountryCode = stateData[i]["countryCode"];
              //                     break;
              //                   }
              //                 }
              //                 setState(() {
              //                   selState = val;
              //                 });
              //                 getCity(selectedStateCode,selectedCountryCode);
              //               },
              //               //value: selState,
              //               items: states.map<DropdownMenuItem<String>>(
              //                   (String value) {
              //                 return DropdownMenuItem<String>(
              //                   value: value,
              //                   child: new Text(
              //                     value,
              //                     style: new TextStyle(color: Colors.black),
              //                   ),
              //                 );
              //               }).toList(),
              //             ),
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 10.0, bottom: 8),
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text(
              //         "Select City",
              //         style: TextStyle(
              //             fontSize: 15, fontWeight: FontWeight.w600),
              //       ),
              //       // Padding(
              //       //   padding: const EdgeInsets.only(top: 10.0),
              //       //   child: GestureDetector(
              //       //     onTap: () async {
              //       //       await _showCityDialog(context);
              //       //     },
              //       //     child: Container(
              //       //       width: MediaQuery.of(context).size.width,
              //       //       height: 50,
              //       //       decoration: BoxDecoration(
              //       //         border: Border.all(
              //       //           color: Colors.grey,
              //       //           // width: 2,
              //       //         ),
              //       //         borderRadius: BorderRadius.circular(5),
              //       //       ),
              //       //       child: Row(
              //       //         children: [
              //       //           Expanded(
              //       //               child: Padding(
              //       //             padding: const EdgeInsets.only(left: 8.0),
              //       //             child: Text(
              //       //               cityName == "" || cityName == null
              //       //                   ? "Select City "
              //       //                   : cityName,
              //       //               style: TextStyle(fontSize: 18),
              //       //             ),
              //       //           )),
              //       //           Padding(
              //       //             padding: const EdgeInsets.only(right: 8.0),
              //       //             child: Icon(
              //       //               Icons.arrow_drop_down,
              //       //               size: 30,
              //       //             ),
              //       //           )
              //       //         ],
              //       //       ),
              //       //     ),
              //       //   ),
              //       // )
              //       Container(
              //         width: MediaQuery.of(context).size.width,
              //         decoration: BoxDecoration(
              //           border: Border.all(color: Colors.grey),
              //           borderRadius: BorderRadius.circular(5),
              //         ),
              //         child: DropdownButtonHideUnderline(
              //           child: Padding(
              //             padding: const EdgeInsets.only(left: 8.0),
              //             child: DropdownButton<String>(
              //               icon: Icon(
              //                 Icons.arrow_drop_down,
              //                 size: 30,
              //               ),
              //               //isDense: true,
              //               hint: new Text(selCity),
              //               // value: _memberClass,
              //               onChanged: (val) {
              //                 print(val);
              //                 societies = [];
              //                 for (int i = 0; i < cityData.length; i++) {
              //                   if (cityData[i]["name"] == val.toString()) {
              //                     // cityId = cityData[i]["_id"].toString();
              //                   }
              //                 }
              //                 setState(() {
              //                   selCity = val;
              //                 });
              //                 // getSocietyList();
              //               },
              //               //value: selCity,
              //               items: cities.map<DropdownMenuItem<String>>(
              //                   (String value) {
              //                 return DropdownMenuItem<String>(
              //                   value: value,
              //                   child: new Text(
              //                     value,
              //                     style: new TextStyle(color: Colors.black),
              //                   ),
              //                 );
              //               }).toList(),
              //             ),
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              Padding(
                padding:
                const EdgeInsets.only(top: 15.0, right: 5.0, left: 5.0),
                child: Row(
                  children: <Widget>[
                    Text("State",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SearchableDropdown.single(
                  items: stateClassList,
                  value: selectedState,
                  hint: "Select Your State",
                  searchHint: "Select one",
                  onClear: (){
                    setState(() {
                      buttonPressed = false;
                    });
                  },
                  onChanged: (value) {
                    print(value);
                    print(selectedState);
                    for(int i=0;i<allStates.length;i++){
                      if(allStates[i]["name"].toString() == value){
                        print("true");
                        FocusScope.of(context)
                            .requestFocus(FocusNode());
                        selectedStateCode = allStates[i]["isoCode"];
                        selectedCountryCode = allStates[i]["countryCode"];
                        break;
                      }
                    }
                    // pr.show();
                    getCity(selectedStateCode,selectedCountryCode);
                    setState(() {
                      selectedState = value;
                    });
                  },
                  isExpanded: true,
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.only(top: 15.0, right: 5.0, left: 5.0),
                child: Row(
                  children: <Widget>[
                    Text("City",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SearchableDropdown.single(
                  items: cityClassList,
                  value: selectedCity,
                  hint: "Select Your City",
                  searchHint: "Select one",
                  onClear: (){
                    print('hi');
                    print(selectedCity);
                  },
                  onChanged: (newValue) {
                    setState(() {
                      selectedCity = newValue;
                      // _cityDropdownError = null;
                      // areaClassList = [];
                    });
                    for(int i=0;i<allCities.length;i++){
                      if(newValue==allCities[i]["name"]){
                        selectedStateCode = allCities[i]["stateCode"];
                        selectedCity = allCities[i]["name"];
                        break;
                      }
                    }
                    // pr.show();
                    // getArea(selectedStateCode,selectedCity);
                  },
                  isExpanded: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Select Society",
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SearchableDropdown.single(
                        items: allSocieties,
                        value: selYourSociety,
                        hint: "Select Your Society",
                        searchHint: "Select one",
                        // onClear: (){
                        //   print('hi');
                        //   print(selYourSociety);
                        //   if(selYourSociety==null){
                        //     setState(() {
                        //       CodeControler.text = "";
                        //       selectedFlat = null;
                        //     });
                        //   }
                        // },
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

                  ],
                ),
              ),
              wingList.length > 0
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
                                      getFlats(selectedSocietyId,selectedWingId);
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
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Flat No.",
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 10.0),
                    //   child: GestureDetector(
                    //     onTap: () async {
                    //       await _showCityDialog(context);
                    //     },
                    //     child: Container(
                    //       width: MediaQuery.of(context).size.width,
                    //       height: 50,
                    //       decoration: BoxDecoration(
                    //         border: Border.all(
                    //           color: Colors.grey,
                    //           // width: 2,
                    //         ),
                    //         borderRadius: BorderRadius.circular(5),
                    //       ),
                    //       child: Row(
                    //         children: [
                    //           Expanded(
                    //               child: Padding(
                    //             padding: const EdgeInsets.only(left: 8.0),
                    //             child: Text(
                    //               cityName == "" || cityName == null
                    //                   ? "Select City "
                    //                   : cityName,
                    //               style: TextStyle(fontSize: 18),
                    //             ),
                    //           )),
                    //           Padding(
                    //             padding: const EdgeInsets.only(right: 8.0),
                    //             child: Icon(
                    //               Icons.arrow_drop_down,
                    //               size: 30,
                    //             ),
                    //           )
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // )
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: DropdownButton<dynamic>(
                            icon: Icon(
                              Icons.arrow_drop_down,
                              size: 30,
                            ),
                            //isDense: true,
                            hint: new Text(selFlat),
                            // value: _memberClass,
                            onChanged: (val) {
                              setState(() {
                                selFlat = val;
                              });
                            },
                            //value: selCity,
                            items: flatList.map<DropdownMenuItem<dynamic>>(
                                    (dynamic value) {
                                  return DropdownMenuItem<dynamic>(
                                    value: value["flatNo"],
                                    child: new Text(
                                      value["flatNo"],
                                      style: new TextStyle(color: Colors.black),
                                    ),
                                  );
                                }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Flat Holder Type",
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 10.0),
                    //   child: GestureDetector(
                    //     onTap: () async {
                    //       await _showCityDialog(context);
                    //     },
                    //     child: Container(
                    //       width: MediaQuery.of(context).size.width,
                    //       height: 50,
                    //       decoration: BoxDecoration(
                    //         border: Border.all(
                    //           color: Colors.grey,
                    //           // width: 2,
                    //         ),
                    //         borderRadius: BorderRadius.circular(5),
                    //       ),
                    //       child: Row(
                    //         children: [
                    //           Expanded(
                    //               child: Padding(
                    //             padding: const EdgeInsets.only(left: 8.0),
                    //             child: Text(
                    //               cityName == "" || cityName == null
                    //                   ? "Select City "
                    //                   : cityName,
                    //               style: TextStyle(fontSize: 18),
                    //             ),
                    //           )),
                    //           Padding(
                    //             padding: const EdgeInsets.only(right: 8.0),
                    //             child: Icon(
                    //               Icons.arrow_drop_down,
                    //               size: 30,
                    //             ),
                    //           )
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // )
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: DropdownButton<String>(
                            icon: Icon(
                              Icons.arrow_drop_down,
                              size: 30,
                            ),
                            //isDense: true,
                            hint: new Text(selFlatHolderType),
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
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(
                    left: 12.0, right: 12, top: 20, bottom: 12),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: FlatButton(
                    color: appPrimaryMaterialColor,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        "Add Flat/Villa",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: BorderSide(color: Colors.grey[300],
                        ),
                    ),
                    onPressed: () {
                      print(selState);
                      print(selCity);
                      print(selSociety);
                      print(selWing);
                      print(selState);
                      print(selFlatHolderType);
                      if (selectedState == "" ||
                          selectedCity == '' ||
                          selectedSocietyId == '' ||
                          selectedWing == '' ||
                          selectedFlat == '' ||
                          selFlatHolderType == "") {
                        Fluttertoast.showToast(
                          msg: "Fields can't be empty",
                          toastLength: Toast.LENGTH_LONG,
                          backgroundColor: Colors.purple,
                          textColor: Colors.white,
                        );
                      } else {
                        // _checkLogin();
                        // widget.isUpdate != null ? updateMemberDetails(
                        //     logindata[0]["SocietyId"].toString(),
                        //     logindata[0]["Name"],
                        //     logindata[0]["ContactNo"],
                        //     logindata[0]["FlatNo"],
                        //     logindata[0]["WingId"].toString(),
                        //     selFlatHolderType,
                        //     logindata[0]["Id"].toString(),
                        //     fcmToken: ""
                        // ):
                        addMemberDetails();
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //show dialog for select state
  _showStateDialog(BuildContext context) {
    //show alert dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertStateDialog(
          onState: (String funStataName) {
            setState(() {
              stataName = funStataName;
            });
          },
        );
      },
    );
  }

  //dialog for city
  _showCityDialog(BuildContext context) {
    //show alert dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertCityDialog(
          onCity: (String funCityName) {
            setState(() {
              cityName = funCityName;
            });
          },
        );
      },
    );
  }

  //dialog for Society
  _showSocietyDialog(BuildContext context) {
    //show alert dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertSocietyDialog(
          onSociety: (String funSocietyName) {
            setState(() {
              societyName = funSocietyName;
            });
          },
        );
      },
    );
  }

  //dialog for building
  _showBuildingDialog(BuildContext context) {
    //show alert dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertBuildingDialog(
          onBuilding: (String funBuildName) {
            setState(() {
              buildingName = funBuildName;
            });
          },
        );
      },
    );
  }
}

class AlertStateDialog extends StatefulWidget {
  Function onState;

  AlertStateDialog({this.onState});

  @override
  _AlertStateDialogState createState() => _AlertStateDialogState();
}

class _AlertStateDialogState extends State<AlertStateDialog> {
  List stateList = ["Gujarat", "Bihar", "Andhra Pradesh", "Arunachal Pradesh"];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: new Text(
        "Select State",
        style: TextStyle(
            fontSize: 22,
            color: appPrimaryMaterialColor,
            fontWeight: FontWeight.w400),
      ),
      content: stateListview(),
      actions: <Widget>[
        // usually buttons at the bottom of the dialog
        FlatButton(
          child: new Text(
            'Cancel',
            style: TextStyle(color: appPrimaryMaterialColor, fontSize: 18),
          ),
          onPressed: () {
            Navigator.of(context).pop();;
          },
        ),
        new FlatButton(
          child: new Text(
            'Ok',
            style: TextStyle(color: appPrimaryMaterialColor, fontSize: 18),
          ),
          onPressed: () {
            Navigator.of(context).pop();;
          },
        ),
      ],
    );
  }

  Widget stateListview() {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemCount: stateList.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            widget.onState("${stateList[index]}");
            Navigator.of(context).pop("${stateList[index]}");
          },
          child: ListTile(
            title: Text('${stateList[index]}'),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => Divider(
        thickness: 1,
      ),
    );
  }
}

class AlertCityDialog extends StatefulWidget {
  Function onCity;

  AlertCityDialog({this.onCity});

  @override
  _AlertCityDialogState createState() => _AlertCityDialogState();
}

class _AlertCityDialogState extends State<AlertCityDialog> {
  List cityList = ["Surat", "Udhana", "Kim", "Baroda"];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: new Text(
        "Select City",
        style: TextStyle(
            fontSize: 22,
            color: appPrimaryMaterialColor,
            fontWeight: FontWeight.w400),
      ),
      content: stateListview(),
    );
  }

  Widget stateListview() {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemCount: cityList.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            widget.onCity("${cityList[index]}");
            Navigator.of(context).pop("${cityList[index]}");
          },
          child: ListTile(
            title: Text('${cityList[index]}'),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => Divider(
        thickness: 1,
      ),
    );
  }
}

class AlertSocietyDialog extends StatefulWidget {
  Function onSociety;

  AlertSocietyDialog({this.onSociety});

  @override
  _AlertSocietyDialogState createState() => _AlertSocietyDialogState();
}

class _AlertSocietyDialogState extends State<AlertSocietyDialog> {
  List socList = ["abc", "xyz", "def", "sqa"];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: new Text(
        "Select Society Name",
        style: TextStyle(
            fontSize: 22,
            color: appPrimaryMaterialColor,
            fontWeight: FontWeight.w400),
      ),
      content: stateListview(),
      actions: <Widget>[
        // usually buttons at the bottom of the dialog
        FlatButton(
          child: new Text(
            'Cancel',
            style: TextStyle(color: appPrimaryMaterialColor, fontSize: 18),
          ),
          onPressed: () {
            Navigator.of(context).pop();;
          },
        ),
        new FlatButton(
          child: new Text(
            'Ok',
            style: TextStyle(color: appPrimaryMaterialColor, fontSize: 18),
          ),
          onPressed: () {
            Navigator.of(context).pop();;
          },
        ),
      ],
    );
  }

  Widget stateListview() {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemCount: socList.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            widget.onSociety("${socList[index]}");
            Navigator.of(context).pop("${socList[index]}");
          },
          child: ListTile(
            title: Text('${socList[index]}'),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => Divider(
        thickness: 1,
      ),
    );
  }
}

class AlertBuildingDialog extends StatefulWidget {
  Function onBuilding;

  AlertBuildingDialog({this.onBuilding});

  @override
  _AlertBuildingDialogState createState() => _AlertBuildingDialogState();
}

class _AlertBuildingDialogState extends State<AlertBuildingDialog> {
  List buildingList = [
    "A",
    "B",
    "C",
    "D",
    "E",
    "F",
    "G",
    "H",
    "I",
    "J",
    "K",
    "L"
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: new Text(
        "Select Building",
        style: TextStyle(
            fontSize: 22,
            color: appPrimaryMaterialColor,
            fontWeight: FontWeight.w400),
      ),
      content: stateListview(),
    );
  }

  Widget stateListview() {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemCount: buildingList.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            widget.onBuilding("${buildingList[index]}");
            Navigator.of(context).pop("${buildingList[index]}");
          },
          child: ListTile(
            title: Text('${buildingList[index]}'),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => Divider(
        thickness: 1,
      ),
    );
  }
}
