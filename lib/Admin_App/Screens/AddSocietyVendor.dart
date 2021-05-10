import 'package:flutter/material.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as cnst;
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:dio/dio.dart';
import 'package:flutter_native_image/flutter_native_image.dart';

class AddSocietyVendor extends StatefulWidget {
  Function onAddSocietyVendor;
  Function onAddOthersVendor;
  String vendorBelongsTo;

  AddSocietyVendor({this.onAddSocietyVendor,this.vendorBelongsTo,this.onAddOthersVendor});

  @override
  _AddSocietyVendorState createState() => _AddSocietyVendorState();
}

class _AddSocietyVendorState extends State<AddSocietyVendor> {
  List<String> vendorCategoryList = [];
  List vendorCategoryDetailsList = [];

  String selectedVendorCategory;
  String selectedState;
  String selectedStateCode;
  String selectedCountryCode;
  String selectedCity;
  String vendorCategoryId;
  String societyId;
  String memberId;
  String _path;
  String _fileName;

  bool isLoading = false;
  bool stateLoading = false;
  bool cityLoading = false;
  bool buttonPressed = false;

  File _image;

  List allStates = [];
  List allCities = [];
  List<DropdownMenuItem> stateClassList = [];
  List<DropdownMenuItem> cityClassList = [];

  TextEditingController nameController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController emergencyContactNumberController =
      TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  TextEditingController gstNoController = TextEditingController();
  TextEditingController panNoController = TextEditingController();

  @override
  void initState() {
    getVendorCategory();
    getState();
    _getLocaldata();
  }

  _getLocaldata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    societyId = prefs.getString(cnst.Session.SocietyId);
    memberId = prefs.getString(cnst.Session.Member_Id);
  }

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
              vendorCategoryDetailsList = data.Data;
              for (int i = 0; i < data.Data.length; i++) {
                vendorCategoryList
                    .add(data.Data[i]["vendorCategoryName"].toString());
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

  addVendor() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        String filename = "";
        String filePath = "";
        File compressedFile;
        if (_image != null) {
          ImageProperties properties =
          await FlutterNativeImage.getImageProperties(_image.path);

          compressedFile = await FlutterNativeImage.compressImage(
            _image.path,
            quality: 80,
            targetWidth: 600,
            targetHeight: (properties.height * 600 / properties.width).round(),
          );

          filename = _image.path.split('/').last;
          filePath = compressedFile.path;
        } else if (_path != null && _path != '') {
          filePath = _path;
          filename = _fileName;
        }
        print('hiiiiiii');
        FormData data = FormData.fromMap({
          "vendorCategoryId": vendorCategoryId,
          "Name": nameController.text,
          "Address": addressController.text,
          "ContactNo": contactNumberController.text,
          "EmergencyContactNo": emergencyContactNumberController.text,
          "ContactPerson": memberId,
          "About": aboutController.text,
          "GSTNo": gstNoController.text,
          "PAN": panNoController.text,
          "StateCode": selectedStateCode.toString(),
          "City": selectedCity.toString(),
          "emailId": emailController.text,
          "societyId": societyId,
          "vendorBelongsTo": widget.vendorBelongsTo,
          "vendorImage": (filePath != null && filePath != '')
              ? await MultipartFile.fromFile(filePath,
              filename: filename.toString())
              : null,
        });
        print({
          "vendorCategoryId": vendorCategoryId,
          "Name": nameController.text,
          "Address": addressController.text,
          "ContactNo": contactNumberController.text,
          "EmergencyContactNo": emergencyContactNumberController.text,
          "ContactPerson": memberId,
          "About": aboutController.text,
          "GSTNo": gstNoController.text,
          "PAN": panNoController.text,
          "StateCode": selectedStateCode.toString(),
          "City": selectedCity.toString(),
          "emailId": emailController.text,
          "societyId": societyId,
          "vendorBelongsTo": widget.vendorBelongsTo,
          "vendorImage": (filePath != null && filePath != '')
              ? await MultipartFile.fromFile(filePath,
              filename: filename.toString())
              : null,
        });
        Services.responseHandler(apiName: "member/addVendor", body: data).then(
            (data) async {
          if (data.Data != null && data.IsSuccess == true) {
            setState(() {
              isLoading = false;
              Fluttertoast.showToast(
                  msg: "Vendor Added Successfully",
                  backgroundColor: Colors.green,
                  gravity: ToastGravity.TOP,
                  textColor: Colors.white);
            });
            Navigator.pop(context);
            widget.vendorBelongsTo=='society'?widget.onAddSocietyVendor():widget.onAddOthersVendor();
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

  getState() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          stateLoading = true;
        });
        var body = {"countryCode": "IN"};
        Services.responseHandler(apiName: "admin/getState", body: body).then(
            (data) async {
          setState(() {
            stateLoading = false;
          });
          if (data.Data != null && data.Data.length > 0) {
            print(stateClassList.runtimeType);
            setState(() {
              for (int i = 0; i < data.Data.length; i++) {
                if (!stateClassList.contains(DropdownMenuItem(
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
          setState(() {
            stateLoading = false;
          });
        });
      } else {
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("Something Went Wrong");
      setState(() {
        stateLoading = false;
      });
    }
  }

  getCity(String stateCode, String countryCode) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          cityLoading = true;
        });
        var body = {"countryCode": countryCode, "stateCode": stateCode};
        Services.responseHandler(apiName: "admin/getCity", body: body).then(
            (data) async {
          // pr.hide();
          setState(() {
            cityLoading = false;
          });
          if (data.Data != null && data.Data.length > 0) {
            setState(() {
              for (int i = 0; i < data.Data.length; i++) {
                cityClassList.add(DropdownMenuItem(
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
                // allSocieties.add(data.Data[i]["Address"]);
              }
              allCities = data.Data;
            });
          }
        }, onError: (e) {
          showMsg("$e");
          setState(() {
            cityLoading = false;
          });
        });
      } else {
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("Something Went Wrong");
      setState(() {
        cityLoading = false;
      });
    }
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
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
            new FlatButton(
              child: new Text("OK"),
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

  @override
  Widget build(BuildContext context) {
    print("vendorCategoryList");
    print(vendorCategoryList);
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Vendor'),
      ),
      body: isLoading == false
          ? SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                                            image:
                                                AssetImage('images/user.png'),
                                            fit: BoxFit.cover),
                                        borderRadius: BorderRadius.all(
                                            new Radius.circular(75.0)),
                                        border: Border.all(
                                            width: 2.5, color: Colors.white)),
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
                                            width: 2.5, color: Colors.white)),
                                  ),
                          ],
                        ),
                      ),
                    ),
                    Text(
                      'Vendor Category *:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: DropdownButtonHideUnderline(
                              child: DropdownButton<dynamic>(
                            icon: Icon(
                              Icons.chevron_right,
                              size: 20,
                            ),
                            hint: vendorCategoryList.length > 0
                                ? Text("Select Vendor Category",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600))
                                : Text(
                                    "Vendor Category Not Found",
                                    style: TextStyle(fontSize: 14),
                                  ),
                            value: selectedVendorCategory,
                            onChanged: (val) {
                              vendorCategoryId = '';
                              setState(() {
                                selectedVendorCategory = val;
                              });
                              for (int i = 0;
                                  i < vendorCategoryDetailsList.length;
                                  i++) {
                                if (vendorCategoryDetailsList[i]
                                        ["vendorCategoryName"] ==
                                    selectedVendorCategory) {
                                  setState(() {
                                    vendorCategoryId =
                                        vendorCategoryDetailsList[i]["_id"]
                                            .toString();
                                  });
                                }
                              }
                            },
                            items: vendorCategoryList.map((val) {
                              return new DropdownMenuItem(
                                value: val,
                                child: Text(
                                  val,
                                  style: TextStyle(color: Colors.black),
                                ),
                              );
                            }).toList(),
                          )),
                        ),
                      ),
                    ),
                    Text(
                      'Name *:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Card(
                      elevation: 2,
                      child: TextFormField(
                        controller: nameController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          counterText: "",
                          hintText: "Vendor Name",
                          contentPadding: EdgeInsets.only(left: 8),
                        ),
                      ),
                    ),
                    Text(
                      'Contact *:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Card(
                      elevation: 2,
                      child: TextFormField(
                        controller: contactNumberController,
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          counterText: "",
                          hintText: "Vendor Contact Number",
                          contentPadding: EdgeInsets.only(left: 8),
                        ),
                      ),
                    ),
                    Text(
                      'Emergency Contact:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Card(
                      elevation: 2,
                      child: TextFormField(
                        controller: emergencyContactNumberController,
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          counterText: "",
                          hintText: "Vendor Emergency Contact Number",
                          contentPadding: EdgeInsets.only(left: 8),
                        ),
                      ),
                    ),
                    Text(
                      'Vendor Email:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Card(
                      elevation: 2,
                      child: TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          counterText: "",
                          hintText: "Vendor Email",
                          contentPadding: EdgeInsets.only(left: 8),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 15.0, right: 5.0, left: 5.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "State *",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          )
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
                        onClear: () {
                          setState(() {
                            buttonPressed = false;
                          });
                        },
                        onChanged: (value) {
                          print(value);
                          print(selectedState);
                          for (int i = 0; i < allStates.length; i++) {
                            if (allStates[i]["name"].toString() == value) {
                              print("true");
                              FocusScope.of(context).requestFocus(FocusNode());
                              selectedStateCode = allStates[i]["isoCode"];
                              selectedCountryCode = allStates[i]["countryCode"];
                              break;
                            }
                          }
                          // pr.show();
                          getCity(selectedStateCode, selectedCountryCode);
                          setState(() {
                            selectedState = value;
                          });
                        },
                        isExpanded: true,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 15.0, right: 5.0, left: 5.0),
                      child: Row(
                        children: <Widget>[
                          Text("City *",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold))
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
                        onClear: () {
                          print('hi');
                          print(selectedCity);
                        },
                        onChanged: (newValue) {
                          setState(() {
                            selectedCity = newValue;
                            // _cityDropdownError = null;
                            // areaClassList = [];
                          });
                          for (int i = 0; i < allCities.length; i++) {
                            if (newValue == allCities[i]["name"]) {
                              selectedStateCode = allCities[i]["stateCode"];
                              selectedCity = allCities[i]["name"];
                              break;
                            }
                          }
                        },
                        isExpanded: true,
                      ),
                    ),
                    Text(
                      'Address:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Card(
                      elevation: 2,
                      child: TextFormField(
                        controller: addressController,
                        keyboardType: TextInputType.text,
                        maxLines: 3,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          counterText: "",
                          hintText: "Vendor Address",
                          contentPadding: EdgeInsets.only(left: 8, top: 5),
                        ),
                      ),
                    ),
                    Text(
                      'About:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Card(
                      elevation: 2,
                      child: TextFormField(
                        controller: aboutController,
                        keyboardType: TextInputType.text,
                        maxLines: 3,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          counterText: "",
                          hintText: "About Vendor",
                          contentPadding: EdgeInsets.only(left: 8, top: 5),
                        ),
                      ),
                    ),
                    Text(
                      'GST Number:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Card(
                      elevation: 2,
                      child: TextFormField(
                        controller: gstNoController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          counterText: "",
                          hintText: "Vendor GST Number",
                          contentPadding: EdgeInsets.only(left: 8),
                        ),
                      ),
                    ),
                    Text(
                      'PAN Number:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Card(
                      elevation: 2,
                      child: TextFormField(
                        controller: panNoController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          counterText: "",
                          hintText: "Vendor PAN Number",
                          contentPadding: EdgeInsets.only(left: 8),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Container(
                        height: 45,
                        width: 170,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          color: cnst.appPrimaryMaterialColor,
                          child: Text(
                            'Add Vendor',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            if(selectedVendorCategory==''||contactNumberController.text==''||selectedState==''||selectedCity==''){
                              Fluttertoast.showToast(
                                  msg: "Please Fill All Mandatory Details",
                                  backgroundColor: Colors.red,
                                  gravity: ToastGravity.TOP,
                                  textColor: Colors.white);
                            }
                            else{
                              // print('Add vendor cicked');
                              addVendor();
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
