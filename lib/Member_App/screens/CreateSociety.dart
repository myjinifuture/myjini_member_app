import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:location/location.dart' as loc;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:smart_society_new/Member_App/common/Classlist.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;
import 'package:smart_society_new/Member_App/screens/SetupWings.dart';
import 'OTP.dart';

class CreateSociety extends StatefulWidget {
  @override
  _CreateSocietyState createState() => _CreateSocietyState();
}

const kGoogleApiKey = "AIzaSyCm9L8-lLCSpRYME1D4lfMb4CS-oX1U6eQ";
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class _CreateSocietyState extends State<CreateSociety> {
  ProgressDialog pr;
  bool isLoading = false;
  String _stateDropdownError, _cityDropdownError;
  bool stateLoading = false;
  bool cityLoading = false;
  bool areaLoading = false;

  List<DropdownMenuItem> stateClassList = [];
  getStateClass _stateClass;
  String selectedState;
  String selectedStateCode,selectedCountryCode;

  List<DropdownMenuItem> cityClassList = [];
  List<DropdownMenuItem> areaClassList = [];
  // List areaClassList = [];
  cityClass _cityClass;
  String selectedCity;
  String selectedArea;
  bool areaAddedToDatabase = false;

  List societyCategoriesList = [];

  String Price_dropdownValue ;
  TextEditingController txtname = new TextEditingController();
  TextEditingController txtmobile = new TextEditingController();
  TextEditingController txtwings = new TextEditingController();
  TextEditingController txtAddress = new TextEditingController();
  TextEditingController txtYourName = new TextEditingController();
  TextEditingController txtEmail = new TextEditingController();
  TextEditingController txtArea = new TextEditingController();

  @override
  void initState() {
    super.initState();
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
        message: "Please Wait..",
        borderRadius: 10.0,
        progressWidget: Container(
          padding: EdgeInsets.all(15),
          child: CircularProgressIndicator(
              //backgroundColor: cnst.appPrimaryMaterialColor,
              ),
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w600));
    getAllSocietyCategory();
  }

  getAllSocietyCategory() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var body = {};
        Services.responseHandler(apiName: "admin/getAllSocietyCategory",body: body).then((data) async {
          if (data.Data != null && data.Data.length > 0) {
            setState(() {
              societyCategoriesList = data.Data;
            });
            // for(int i=0;i<data.Data.length;i++){
            //   if(data.Data[i]["categoryName"] == "Industrial" ||
            //       data.Data[i]["categoryName"] == "Commercial"){
            //     societyCategoriesList.remove(data.Data[i]);
            //   }
            // }
            getState();
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

  List allStates = [];
  getState() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          stateLoading = true;
        });
        var body = {
          "countryCode" : "IN"
        };
        Services.responseHandler(apiName: "admin/getState",body: body).then((data) async {
          setState(() {
            stateLoading = false;
          });
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

  List allCities = [];
  getCity(String stateCode,String countryCode) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          cityLoading = true;
        });
        var body = {
          "countryCode" : countryCode,
          "stateCode" : stateCode
        };
        Services.responseHandler(apiName: "admin/getCity",body: body).then((data) async {
          // pr.hide();
          setState(() {
            cityLoading = false;
          });
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

  List allAreas = [];
  bool enteredManually = false;
  addArea(String area) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          areaLoading = true;
        });
        var body = {
          "Title" : area,
          "stateCode" : selectedStateCode,
          "city" : selectedCity
        };
        Services.responseHandler(apiName: "admin/addAreaOfCity",body: body).then((data) async {
          // pr.hide();
          setState(() {
            areaLoading = false;
          });
          if (data.Data != null && data.Data.length > 0) {
            // getArea(data.Data[0]["stateCode"], data.Data[0]["city"]);
            areaClassList.add(
                DropdownMenuItem(
                  child: Column(
                    children: [
                      Text(area),
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Container(
                          color: Colors.black,
                          height: 0.5,
                        ),
                      ),
                    ],
                  ),
                  value: area,
                ));
            // for(int i=0;i<allAreas.length;i++){
            //   if(area==allAreas[i]["Title"].toString()){
            //     areaIdSentToBackend = allAreas[i]["_id"];
            //     break;
            //   }
            // }
            setState(() {
              areaIdSentToBackend = data.Data[0]["_id"];
              selectedArea = area;
              _cityDropdownError = null;
              enteredManually = true;
              selectedArea = area;
            });
            print("areaIdSentToBackend");
            print(areaIdSentToBackend);
            Navigator.of(context).pop();;
            Navigator.of(context).pop();;
          }
        }, onError: (e) {
          showMsg("$e");
          setState(() {
            areaLoading = false;
          });
        });
      } else {
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("Something Went Wrong");
      setState(() {
        areaLoading = false;
      });
    }
  }

  String areaIdSentToBackend;
  getArea(String stateCode,String city) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          areaLoading = true;
        });
        var body = {
          "stateCode" : stateCode,
          "city":city
        };
        Services.responseHandler(apiName: "admin/getCityArea",body: body).then((data) async {
          // pr.hide();
          setState(() {
            areaLoading = false;
          });
          if (data.Data != null && data.Data.length > 0) {
            areaClassList.clear();
            setState(() {
                for(int i=0;i<data.Data.length;i++){
                  if(!areaClassList.contains(DropdownMenuItem(
                    child: Column(
                      children: [
                        Text(data.Data[i]["Title"]),
                        Padding(
                          padding: const EdgeInsets.only(top:12.0),
                          child: Container(
                            color: Colors.black,
                            height: 0.5,
                          ),
                        ),
                      ],
                    ),
                    value: data.Data[i]["Title"],
                  ))) {
                    areaClassList.add(
                        DropdownMenuItem(
                          child: Column(
                            children: [
                              Text(data.Data[i]["Title"]),
                              Padding(
                                padding: const EdgeInsets.only(top: 12.0),
                                child: Container(
                                  color: Colors.black,
                                  height: 0.5,
                                ),
                              ),
                            ],
                          ),
                          value: data.Data[i]["Title"],
                        ));
                  }
                  // allSocieties.add(data.Data[i]["Address"]);
                }
                print("areaClassList");
                allAreas = data.Data;
              // areaClassList = data.Data;
              areaAddedToDatabase = true;
            });
          }
        }, onError: (e) {
          showMsg("$e");
          setState(() {
            areaLoading = false;
          });
        });
      } else {
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("Something Went Wrong");
      setState(() {
        areaLoading = false;
      });
    }
  }


  String selectedSocietyCode="",selectedAreaId="";
  createNewSociety(String Name, String Address, String ContactPerson, String ContactMobile, String StateId, String selectedCity, String selectedArea, String Location, String lat,String long, String email, String SocietyType, String NoofWings) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // pr.show();
        for(int i=0;i<societyCategoriesList.length;i++){
          if(SocietyType==societyCategoriesList[i]["categoryName"]){
            selectedSocietyCode = societyCategoriesList[i]["_id"];
            break;
          }
        }
        for(int i=0;i<allAreas.length;i++){
          if(selectedArea == allAreas[i]["Title"]){
            areaIdSentToBackend = allAreas[i]["_id"];
          }
        }
        print("selectedArea");
        print(areaIdSentToBackend);
        var body = {
          "Name" : Name,
          "Address" : Address,
          "ContactPerson" :ContactPerson,
          "ContactMobile" : ContactMobile,
          "StateCode" : StateId,
          "City" : selectedCity,
          "areaId":areaIdSentToBackend,
          "mapLink" : Location,
          "lat" : lat,
          "long" : long,
          "email" : email,
          "SocietyType" : selectedSocietyCode,
          "NoOfWing" : NoofWings
        };
        print("body");
        print(body);
        Services.responseHandler(apiName: "admin/createSociety",body: body)
            .then((data) async {
          if (data.IsSuccess==true) {
            // pr.show();
            Fluttertoast.showToast(
              msg: "Society Created Successfully",
              gravity: ToastGravity.BOTTOM,
            );
            print("code before wing setup");
            print(data.Data[0]["societyCode"]);
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => SetupWings(
                  Price_dropdownValue:Price_dropdownValue,
                  wingData: txtwings.text,
                  societyId: data.Data[0]["_id"].toString(),
                  mobileNo : txtmobile.text,
                    societyCode :data.Data[0]["societyCode"],
                  isEdit: false,
                )));
          }
        }, onError: (e) {
          showMsg("$e");
          // pr.show();
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
                Navigator.of(context).pop();;
              },
            ),
          ],
        );
      },
    );
  }

  final homeScaffoldKey = GlobalKey<ScaffoldState>();
  void onError(PlacesAutocompleteResponse response) {
    homeScaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(response.errorMessage)),
    );
  }

  loc.LocationData currentLocation;
  double lat,long;

  pickAddress() async {
    try {
      print("Current Location");
      Prediction p = await PlacesAutocomplete.show(
        context: context,
        hint:  "Search your location",
        apiKey: kGoogleApiKey,
        onError: onError,
        mode: Mode.overlay,
        language: "en",
        components: [
          Component(Component.country, "in"),
        ],
        location: currentLocation == null
            ? null
            : Location(currentLocation.latitude, currentLocation.longitude),
        //radius: currentLocation == null ? null : 10000
      );
      PlacesDetailsResponse detail =
      await _places.getDetailsByPlaceId(p.placeId);
        setState(() {
          txtAddress.text = p.description;
          lat = detail.result.geometry.location.lat;
          long = detail.result.geometry.location.lng;
        });
    } catch (e) {
      return;
    }
  }

  bool societyExist = false;

  getAllSocieties() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var data = {};
        setState(() {
          isLoading = true;
        });
        Services.responseHandler(apiName: "masterAdmin/getSocietyList",body: data).then((data) async {
          print(data.Data);
          if (data.Data.length > 0) {
            setState(() {
              for(int i=0;i<data.Data.length;i++){
                if(data.Data[i]["Address"].toString() == txtAddress.text){
                  societyExist = true;
                }
              }
            });
          } else {
            print("else called");
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
      showMsg("No Internet Connection.");
    }
  }

  bool buttonPressed = false;
  bool isAreaSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Society"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.only(top: 15.0, right: 5.0, left: 5.0),
                child: Row(
                  children: <Widget>[
                    Text("Type",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500))
                  ],
                ),
              ),
              Container(
                height: 45,
                margin: EdgeInsets.only(left: 5.0, right: 5.0, top: 6.0),
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                  border: Border.all(
                      color: Colors.black,
                      style: BorderStyle.solid,
                      width: 0.6),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: Price_dropdownValue,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Colors.black),
                    underline: Container(
                      height: 2,
                      color: Colors.black,
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        Price_dropdownValue = newValue;
                      });
                    },
                    hint: Text("Select"),
                    items: societyCategoriesList.map<DropdownMenuItem<String>>((dynamic value) {
                      return DropdownMenuItem<String>(
                        value: value["categoryName"],
                        child: Text(value["categoryName"]),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 15.0, right: 5.0, left: 5.0),
                child: Row(
                  children: <Widget>[
                    Text("Society",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 6.0),
                child: SizedBox(
                  height: 50,
                  child: TextFormField(
                    validator: (value) {
                      if (value.trim() == "") {
                        return 'Please Enter Name';
                      }
                      return null;
                    },
                    controller: txtname,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(5.0),
                          borderSide: new BorderSide(),
                        ),
                        // labelText: "Society Name",
                        hintText: 'Enter Society Name',
                        hintStyle: TextStyle(fontSize: 13)),
                  ),
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.only(top: 15.0, right: 5.0, left: 5.0),
                child: Row(
                  children: <Widget>[
                    Text("Society Address",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 6.0),
                child: SizedBox(
                  height: 60,
                  child: TextFormField(
                    onTap: (){
                      pickAddress();
                    },
                    validator: (value) {
                      if (value.trim() == "") {
                        return 'Please Enter Name';
                      }
                      return null;
                    },
                    controller: txtAddress,
                    textCapitalization: TextCapitalization.words,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(5.0),
                          borderSide: new BorderSide(),
                        ),
                        // labelText: "Society Name",
                        hintText: 'Pick Society Address',
                        hintStyle: TextStyle(fontSize: 14,),),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 15.0, right: 5.0, left: 5.0),
                child: Row(
                  children: <Widget>[
                    Text("Mobile",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 6.0),
                child: SizedBox(
                  height: 50,
                  child: TextFormField(
                    validator: (value) {
                      if (value.trim() == "" || value.length < 10) {
                        return 'Please Enter 10 Digit Mobile Number';
                      }
                      return null;
                    },
                    maxLength: 10,
                    keyboardType: TextInputType.number,
                    controller: txtmobile,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        counterText: "",
                        fillColor: Colors.grey[200],
                        contentPadding:
                            EdgeInsets.only(top: 5, left: 10, bottom: 5),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide:
                                BorderSide(width: 0, color: Colors.black)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide:
                                BorderSide(width: 0, color: Colors.black)),
                        hintText: 'Enter Mobile No',
                        // labelText: "Mobile",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 14)),
                  ),
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.only(top: 15.0, right: 5.0, left: 5.0),
                child: Row(
                  children: <Widget>[
                    Text("Your Name",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 6.0),
                child: SizedBox(
                  height: 50,
                  child: TextFormField(
                    validator: (value) {
                      if (value.trim() == "") {
                        return 'Please Enter Name';
                      }
                      return null;
                    },
                    controller: txtYourName,
                    textCapitalization: TextCapitalization.words,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                        borderSide: new BorderSide(),
                      ),
                      // labelText: "Society Name",
                      hintText: 'Your Name',
                      hintStyle: TextStyle(fontSize: 14,),),
                  ),
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.only(top: 15.0, right: 5.0, left: 5.0),
                child: Row(
                  children: <Widget>[
                    Text("Your Email",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 6.0),
                child: SizedBox(
                  height: 50,
                  child: TextFormField(
                    validator: (value) {
                      if (value.trim() == "" || !value.trim().contains("@")) {
                        return 'Please Enter Email Id';
                      }
                      return null;
                    },
                    controller: txtEmail,
                    textCapitalization: TextCapitalization.words,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                        borderSide: new BorderSide(),
                      ),
                      // labelText: "Society Name",
                      hintText: 'Your Email',
                      hintStyle: TextStyle(fontSize: 14,),),
                  ),
                ),
              ),
              Price_dropdownValue.toString()=="Society"||Price_dropdownValue==null?Padding(
                padding:
                    const EdgeInsets.only(top: 15.0, right: 5.0, left: 5.0),
                child: Row(
                  children: <Widget>[
                    Text("Total Wings",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500))
                  ],
                ),
              ):Container(),
              Price_dropdownValue.toString()=="Society"||Price_dropdownValue==null?Padding(
                padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 6.0),
                child: SizedBox(
                  height: 50,
                  child: TextFormField(
                    validator: (value) {
                      if (value.trim() == "") {
                        return 'Enter Total Wings';
                      }
                      return null;
                    },
                    maxLength: 2,
                    keyboardType: TextInputType.number,
                    controller: txtwings,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        counterText: "",
                        fillColor: Colors.grey[200],
                        contentPadding:
                            EdgeInsets.only(top: 5, left: 10, bottom: 5),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide:
                                BorderSide(width: 0, color: Colors.black)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide:
                                BorderSide(width: 0, color: Colors.black)),
                        hintText: 'Enter Total No of Wings',
                        // labelText: "Wings",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 14)),
                  ),
                ),
              ):Container(),

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
                      _cityDropdownError = null;
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
                    getArea(selectedStateCode,selectedCity);
                  },
                  isExpanded: true,
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.only(top: 15.0, right: 5.0, left: 5.0),
                child: Row(
                  children: <Widget>[
                    Text("Area",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500))
                  ],
                ),
              ),
              enteredManually ? Container(): Padding(
                padding: const EdgeInsets.all(8.0),
                child: SearchableDropdown.single(
                  items: areaClassList,
                  value: selectedArea,
                  hint: "Select Your Area",
                  searchHint: "Select one",
                  onClear: (){
                    print('hi');
                    print(selectedArea);
                  },
                  closeButton: RaisedButton(
                    color: constant.appPrimaryMaterialColor,
                    child: Text("Add New Area",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    ),
                    onPressed: () {
                      txtArea.text = "";
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            // title: Text("Simple Alert"),
                            content:Padding(
                              padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 15.0),
                              child: SizedBox(
                                height: 50,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value.trim() == "") {
                                      return 'Enter Your Area';
                                    }
                                    return null;
                                  },
                                  // maxLength: 2,
                                  // keyboardType: TextInputType.number,
                                  controller: txtArea,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                      counterText: "",
                                      fillColor: Colors.grey[200],
                                      contentPadding:
                                      EdgeInsets.only(top: 5, left: 10, bottom: 5),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(5)),
                                          borderSide:
                                          BorderSide(width: 0, color: Colors.black)),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(4)),
                                          borderSide:
                                          BorderSide(width: 0, color: Colors.black)),
                                      hintText: 'Enter Area',
                                      // labelText: "Wings",
                                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14)),
                                ),
                              ),
                            ),
                            actions: [
                              RaisedButton(
                                  color: constant.appPrimaryMaterialColor,
                                  child: Text("Submit",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  onPressed: () {
                                    bool exist = false;
                                    for(int i=0;i<allAreas.length;i++){
                                      if(allAreas[i]["Title"].toString().toLowerCase() == txtArea.text){
                                        exist = true;
                                        Fluttertoast.showToast(
                                          msg: "Already Exist!!",
                                          gravity: ToastGravity.TOP,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                        );
                                      }
                                    }
                                    if(!exist){
                                      addArea(txtArea.text);
                                    }
                                  }),
                            ],
                          );
                        },
                      );
                    }),
                  onChanged: (newValue) {
                    setState(() {
                      isAreaSelected = true;
                      selectedArea = newValue;
                      _cityDropdownError = null;
                      // areaClassList = [];
                    });
                    // for(int i=0;i<allAreas.length;i++){
                    //   if(newValue==allAreas[i]["Title"].toString()){
                    //     // selectedStateCode = allCities[i]["stateCode"];
                    //     // selectedCity = allCities[i]["name"];
                    //     areaIdSentToBackend = allAreas[i]["_id"];
                    //     break;
                    //   }
                    // }
                    setState(() {
                      selectedArea = newValue;
                    });
                    // pr.show();
                  },
                  isExpanded: true,
                ),
              ),
              enteredManually ?  Padding(
                padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 15.0),
                child: SizedBox(
                  height: 50,
                  child: TextFormField(
                    validator: (value) {
                      if (value.trim() == "") {
                        return 'Enter Your Area';
                      }
                      return null;
                    },
                    // maxLength: 2,
                    // keyboardType: TextInputType.number,
                    controller: txtArea,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        counterText: "",
                        fillColor: Colors.grey[200],
                        contentPadding:
                        EdgeInsets.only(top: 5, left: 10, bottom: 5),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide:
                            BorderSide(width: 0, color: Colors.black)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide:
                            BorderSide(width: 0, color: Colors.black)),
                        hintText: 'Enter Area',
                        // labelText: "Wings",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 14)),
                    onChanged: (val){
                      setState(() {
                        isAreaSelected = true;
                      });
                    },
                  ),
                ),
              ):Container(),
              // Padding(
              //   padding:
              //   const EdgeInsets.only(top: 15.0, right: 5.0, left: 5.0),
              //   child: Row(
              //     children: <Widget>[
              //       Text("Area",
              //           style: TextStyle(
              //               fontSize: 15, fontWeight: FontWeight.w500))
              //     ],
              //   ),
              // ),
              // Container(
              //   height: 45,
              //   margin: EdgeInsets.only(left: 5.0, right: 5.0, top: 6.0),
              //   width: MediaQuery.of(context).size.width,
              //   padding: EdgeInsets.symmetric(horizontal: 10),
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(5),
              //     color: Colors.white,
              //     border: Border.all(
              //         color: Colors.black,
              //         style: BorderStyle.solid,
              //         width: 0.6),
              //   ),
              //   child: DropdownButtonHideUnderline(
              //     child: DropdownButton<dynamic>(
              //       isExpanded: true,
              //       hint: areaClassList.length > 0
              //           ? Text(
              //         'Select Area',
              //         style: TextStyle(fontSize: 12),
              //       )
              //           : Text(
              //         "Area Not Found",
              //         style: TextStyle(fontSize: 12),
              //       ),
              //       value: selectedArea,
              //       onChanged: (newValue) {
              //         setState(() {
              //           selectedArea = newValue;
              //           // _cityDropdownError = null;
              //         });
              //       },
              //       items: areaClassList.map((DropdownMenuItem value) {
              //         return DropdownMenuItem<dynamic>(
              //           value: value.value,
              //           child: Text(value.value),
              //         );
              //       }).toList(),
              //     ),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0, left: 8, right: 8),
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
                        "Create",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600)),
                    onPressed: isAreaSelected ? () {
                      print(txtname.text);
                      print(txtmobile.text);
                      print(txtwings.text);
                      if (Price_dropdownValue == "Select" ||
                          txtname.text == "" ||
                          txtmobile.text == "" ||
                          // txtwings.text == "" ||
                          selectedStateCode == null ||
                          selectedCity == null ||
                          txtYourName.text=="" ||
                          txtAddress.text=="" ||
                          txtEmail.text=="") {
                        Fluttertoast.showToast(
                          msg: "Fields can't be empty",
                          gravity: ToastGravity.TOP,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                        );
                      } else {
                        setState(() {
                          buttonPressed = true;
                        });
                        getAllSocieties();
                        // addArea(txtArea.text);
                       // createNewSociety(txtname.text, txtAddress.text, txtYourName.text, txtmobile.text,
                       //     selectedStateCode, selectedCity,selectedArea, "http://maps.google.com/maps?q=$lat,$long",
                       //      lat.toString(),long.toString(), txtEmail.text, Price_dropdownValue, txtwings.text);
                        if(!societyExist && areaAddedToDatabase) {
                          // createNewSociety(
                          //     txtname.text,
                          //     txtAddress.text,
                          //     txtYourName.text,
                          //     txtmobile.text,
                          //     selectedStateCode,
                          //     selectedCity,
                          //     selectedArea,
                          //     "http://maps.google.com/maps?q=$lat,$long",
                          //     lat.toString(),
                          //     long.toString(),
                          //     txtEmail.text,
                          //     Price_dropdownValue,
                          //     txtwings.text);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    OTP(
                                        mobileNo: txtmobile.text.toString(),
                                        onSuccess: () {
                                          createNewSociety(
                                              txtname.text,
                                              txtAddress.text,
                                              txtYourName.text,
                                              txtmobile.text,
                                              selectedStateCode,
                                              selectedCity,
                                              selectedArea,
                                              "http://maps.google.com/maps?q=$lat,$long",
                                              lat.toString(),
                                              long.toString(),
                                              txtEmail.text,
                                              Price_dropdownValue,
                                              txtwings.text);
                                        }),
                              ));
                        }
                        else{
                          Fluttertoast.showToast(
                            msg: "Society Already Exist!!",
                            toastLength: Toast.LENGTH_LONG,
                            backgroundColor: Colors.red,
                            gravity: ToastGravity.TOP,
                            textColor: Colors.white,
                          );
                        }
                      }
                      //Navigator.pushNamed(context, '/SetupWings');
                    }:null,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
