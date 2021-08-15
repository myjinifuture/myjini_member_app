import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'dart:io';
import 'package:smart_society_new/Member_App/common/vaccinationServices.dart';
import '../common/vaccinationDistrictServices.dart';
import '../common/vaccinationPincodeServices.dart';

class VaccinationCenter extends StatefulWidget {
  @override
  _VaccinationCenterState createState() => _VaccinationCenterState();
}

class _VaccinationCenterState extends State<VaccinationCenter> {
  TextEditingController _txtPincodeSearch = TextEditingController();

  List vaccinationstateList = [];
  List districtList = [];
  List pincodeList = [];
  List filtredPincodeList = [];

  bool isPincode = true;
  bool isDistrict = false;

  bool isSearch = false;
  var latitude;
  var longitude;
  String vaccineUrl = "";
  String pincodeUrl = "";
  String districturl = "";

  double totalDistance = 0;
  var pincode;
  double latvalue = 0.0;

  String _currentState;
  String _currentDistrict;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getlocation();
  }

  getlocation() {
    setState(() {
      vaccineUrl = "https://cdn-api.co-vin.in/api/v2/admin/location/states";
      getallvaccinationData(vaccineUrl);
    });
  }

  /* void getCurrentLocation() async {
    var answer = await Geolocator.getCurrentPosition();
    LocationData myLocation;
    String error;
    Location location = new Location();
    try {
      myLocation = await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'please grant permission';
        print(error);
      }
      if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error = 'permission denied- please enable it from app settings';
        print(error);
      }
      myLocation = null;
    }
    currentLocation = myLocation;
    final coordinates =
        new Coordinates(myLocation.latitude, myLocation.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    pincode = first.postalCode;
    DateTime dateToday = new DateTime.now();
    String date = DateFormat("dd-MM-yyyy").format(DateTime.now());
    setState(() {
      latitude = answer.latitude.toString();
      longitude = answer.longitude.toString();

      //vaccineUrl = "https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/findByPin?pincode=$pincode&date=$date";
    });

  }*/

  /*calculateDistance(latitude, longitude, lat2, lon2) {
    var lat2 = double.parse(vaccinationList[0]["lat"]);
    var log2 = double.parse(vaccinationList[0]["long"]);
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - latitude) * p) / 2 +
        c(latitude * p) * c(lat2 * p) * (1 - c((lon2 - longitude) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }*/

  getallvaccinationData(String stateurl) async {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      var body = {};
      VaccinationServices.responseHandler(apiName: vaccineUrl, body: body).then(
          (data) async {
        if (data.states.length > 0) {
          setState(() {
            vaccinationstateList = data.states;
          });
        }
      }, onError: (e) {
        //  showMsg("$e");
      });
    }
  }

  getallvaccinationdistrictData(String id) async {
    districturl =
        "https://cdn-api.co-vin.in/api/v2/admin/location/districts/$id";
    final result = await InternetAddress.lookup('google.com');

    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      var body = {};
       VaccinationDistrictServices.responseHandler(
              apiName: districturl, body: body)
          .then((data) async {
        if (data.districts.length > 0) {
          districtList.clear();
            print(["data.districts::", data.districts, districtList]);
            districtList.addAll(data.districts);
          setState(() {
            districtList.toSet().toList();
            // districtList = data.districts != null ? data.districts : [];
          });
        }
      }, onError: (e) {
        //  showMsg("$e");
      });
    }
  }

  getallPincodeData(String id) async {
    String date = DateFormat("dd-MM-yyyy").format(DateTime.now());
    pincodeUrl =
        "https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/findByDistrict?district_id=${_currentDistrict}&date=$date";
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      var body = {};
      VaccinationPincodeServices.responseHandler(
              apiName: pincodeUrl, body: body)
          .then((data) async {
        if (data.sessions.length > 0) {
          setState(() {
            print(["data.sessions", data.sessions]);
            pincodeList = data.sessions;
            filtredPincodeList = data.sessions;
          });
        } else {
          data.sessions = "";
        }
      }, onError: (e) {
        //  showMsg("$e");
      });
    }
  }

  /*filteredDistrict(String value) {
    setState(() {
      filtredDistrictList = vaccinationList
          .where((name) => name["district_name"]
              .toString()
              .toLowerCase()
              .contains(value.toString().toLowerCase()))
          .toList();
    });
  }*/

  filteredPincode(String value) {
    setState(() {
      filtredPincodeList = pincodeList
          .where(
              (name) => name["pincode"].toString().contains(value.toString()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "Vaccination Center",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontFamily: "OpenSans"),
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple, Colors.deepPurple],
                stops: [0.1, 7.0],
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                /*Container(
                  width: MediaQuery.of(context).size.width,
                  height: 170,
                  child: Carousel(
                    boxFit: BoxFit.cover,
                    images: [
                      AssetImage("assets/image/v4.jpg"),
                      AssetImage("assets/image/v2.jpg"),
                      AssetImage("assets/image/v3.jpg"),
                      AssetImage("assets/image/v1.jpg"),
                    ],
                    autoplay: true,
                    autoplayDuration: Duration(seconds: 2),
                    indicatorBgPadding: 8,
                    dotSize: 4,
                  ),
                ),*/
                Padding(padding: EdgeInsets.only(top: 10.0)),
                districtList.length == 0
                    ? stateDropdownList()
                    : SizedBox(),
                districtList.length > 0 ? districtDropdownList() : SizedBox(),
                Padding(padding: EdgeInsets.only(top: 10.0)),
                districtList.length > 0 ? searchBar() : Container(),
                Padding(padding: EdgeInsets.only(top: 10.0)),
                vaccinationstateList.length > 0
                    ? filtredPincodeList.length > 0
                        ? Container(
                            child: Column(
                              children: [
                                ListView.builder(
                                    physics: BouncingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: filtredPincodeList.length,
                                    itemBuilder: (context, index) =>
                                        listviewPincodedata(index)),
                              ],
                            ),
                          )
                        : /*filtredDistrictList.length > 0
                      ? ListView.builder(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: vaccinationList.length,
                          itemBuilder: (context, index) => isDistrict
                              ? listviewDistrictdata(index)
                              : null,
                        )
                      : */
                        Column(
                            children: [
                              Padding(padding: EdgeInsets.only(top: 150.0)),
                              filtredPincodeList.length > 0
                                  ? Container()
                                  : CircularProgressIndicator(),
                            ],
                          )
                    : Center(
                        child: Container(
                            margin: EdgeInsets.only(top: 180),
                            child: Lottie.asset(
                                "assets/json/splash_loader.json",
                                width: 100,
                                height: 100)),
                      )
              ],
            ),
          ),
        ));
  }

  stateDropdownList() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton<String>(
              value: _currentState,
              iconSize: 30,
              dropdownColor: Colors.deepPurple[50],
              icon: (null),
              style: TextStyle(
                fontFamily: "OpenSans",
                color: Colors.black54,
                fontSize: 14,
              ),
              hint: Text('Select State'),
              onChanged: (String newValue) async {
                districtList.clear();
                 setState(()  {
                  print("++++++++++++++++++++");
                  _currentState = newValue;
                  print(_currentState);
                  print("++++++++++++++++++++State Over");
                });
                  await getallvaccinationdistrictData(newValue);
              },
              items: vaccinationstateList?.map((itemState) {
                    return DropdownMenuItem(
                      child: Text(itemState['state_name']),
                      value: itemState['state_id'].toString(),
                    );
                  })?.toList() ??
                  [
                    DropdownMenuItem(
                      child: Text("No State Available"),
                      value: "-1",
                    )
                  ],
            ),
          ),
        ),
      ),
    );
  }

  districtDropdownList() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton<String>(
                value: _currentDistrict,
                iconSize: 30,
                dropdownColor: Colors.deepPurple[50],
                icon: (null),
                style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                    fontFamily: "OpenSans"),
                hint: Text('Select District'),
                onChanged: (String newValue) {
                  setState(() {
                    print(["_currentDistrict", _currentDistrict, newValue]);
                    if (newValue != "-1") {
                      _currentDistrict = newValue;
                      print("----------------------");
                      getallPincodeData(_currentDistrict);
                      print("----------------------district");
                    }
                    //thy gy solve
                  });
                },
                items: districtList != null && districtList.isNotEmpty
                    ? districtList.map((itemDistrict) {
                        return DropdownMenuItem(
                          child: Text(itemDistrict['district_name']),
                          value: itemDistrict['district_id'].toString(),
                        );
                      }).toList()
                    : [
                        DropdownMenuItem(
                          child: Text("No District Available"),
                          value: "7",
                        )
                      ]),
          ),
        ),
      ),
    );
  }

  searchBar() {
    return Row(
      children: [
        Padding(padding: EdgeInsets.only(left: 15.0)),
        !isSearch
            ? Row(
                children: [
                  Text(
                    "Search By Pincode",
                    style: TextStyle(fontSize: 16, fontFamily: "OpenSans"),
                  ),
                  Padding(padding: EdgeInsets.only(left: 130))
                ],
              )
            : Container(
                width: 272,
                child: TextField(
                  controller: _txtPincodeSearch,
                  onChanged: filteredPincode,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    icon: Icon(
                      Icons.search,
                      size: 25,
                    ),
                    hintText: "Search...",
                  ),
                )),
        Padding(padding: EdgeInsets.only(left: 5)),
        isSearch
            ? IconButton(
                icon: Icon(Icons.cancel),
                onPressed: () {
                  setState(() {
                    this.isSearch = false;
                  });
                },
              )
            : IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  setState(() {
                    this.isSearch = true;
                  });
                },
              )
      ],
    );
  }

  /*SerchingUI() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
      child: Row(
        children: [
          Padding(padding: EdgeInsets.only(left: 9.0)),
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: 35,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: Colors.deepPurple,
                  width: 1.0,
                )),
            child: Row(
              children: [
                Container(
                  width: 161,
                  child: RaisedButton(
                    onPressed: () {
                      if (isPincode == true) {
                        setState(() {
                          isPincode = true;
                        });
                      } else {
                        setState(() {
                          isDistrict = false;
                          isPincode = !isPincode;
                        });
                      }
                    },
                    child: Text(
                      "Pincode",
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: "OpenSans",
                          color: isPincode ? Colors.white : Colors.deepPurple),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                    color: isPincode ? Colors.deepPurple : Colors.white,
                  ),
                ),
                Container(
                  width: 161,
                  child: RaisedButton(
                    onPressed: () {
                      if (isDistrict == true) {
                        setState(() {
                          isDistrict = true;
                        });
                      } else {
                        setState(() {
                          isPincode = false;
                          isDistrict = !isDistrict;
                        });
                      }
                    },
                    child: Text(
                      "District",
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: "OpenSans",
                          color: isDistrict ? Colors.white : Colors.deepPurple),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                    color: isDistrict ? Colors.deepPurple : Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }*/

  /* listviewDistrictdata(index) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        shadowColor: Colors.deepPurple,
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(children: [
            Row(
              children: [
                ContainerNL(
                    "Center Name   :", filtredDistrictList[index]["name"]),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 10.0)),
            Row(
              children: [
                ContainerUI("District              :",
                    filtredDistrictList[index]["district_name"]),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 10.0)),
            Row(
              children: [
                ContainerNL("Location            :",
                    filtredDistrictList[index]["location"]),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 10.0)),
            Row(
              children: [
                ContainerUI("PinCode             :",
                    filtredDistrictList[index]["pincode"]),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 10.0)),
            Row(
              children: [
                ContainerUI("block                  :",
                    filtredDistrictList[index]["block_name"]),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 10.0)),
            Row(
              children: [
                ContainerUI("Near By             :",
                    "${num.parse(calculateDistance(double.parse(latitude), double.parse(longitude), double.parse(filtredDistrictList[index]["lat"]), double.parse(filtredDistrictList[index]["long"])).toString()).toStringAsFixed(2)} km"),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 10.0)),
            Row(
              children: [
                Expanded(
                  child: RaisedButton(
                    onPressed: () async {
                      var url =
                          "https://www.google.com/maps/@=${filtredDistrictList[index]["lat"]},${filtredDistrictList[index]["long"]}";
                      if (await canLaunch(url)) {
                        await launch(url);
                      }else {
                        throw "Coludn't launch Url";
                      }
                    },
                    color: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      "Navigate To Center",
                      style: TextStyle(
                          color: Colors.white, fontFamily: "OpenSans"),
                    ),
                  ),
                )
              ],
            )
          ]),
        ),
      ),
    );
  }*/

  listviewPincodedata(index) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Card(
        color: Colors.deepPurple[50],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.only(
              top: 15.0, left: 15, bottom: 15.0, right: 10.0),
          child: Column(children: [
            Row(
              children: [
                ContainerNL("Center               :",
                    filtredPincodeList[index]["name"]),
              ],
            ),
            Padding(padding: const EdgeInsets.only(top: 10.0)),
            Row(
              children: [
                ContainerNL("Address             :",
                    filtredPincodeList[index]["address"]),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 10.0)),
            Row(
              children: [
                ContainerNL("District              :",
                    filtredPincodeList[index]["district_name"]),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 10.0)),
            Row(
              children: [
                ContainerNL("Block                  :",
                    filtredPincodeList[index]["block_name"]),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 10.0)),
            Row(
              children: [
                ContainerNL("Vaccine             :",
                    (filtredPincodeList[index]["vaccine"]).toString()),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 10.0)),
            Row(
              children: [
                ContainerNL("Pincode             :",
                    (filtredPincodeList[index]["pincode"]).toString()),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 10.0)),
            Row(
              children: [
                ContainerNL("Feetype             :",
                    (filtredPincodeList[index]["fee_type"])),
              ],
            ),
            /*Padding(padding: EdgeInsets.only(top: 10.0)),
            Row(
              children: [
                Expanded(
                  child: RaisedButton(
                    onPressed: () async {
                      //navigateTo(21.163744,72.8213255);
                      print((vaccinationList[index]["lat"]));
                      print((vaccinationList[index]["long"]));
                      var googleMapsurl =
                          "https://www.google.com/maps/search/?api=1&query=${vaccinationList[index]["lat"].toString()},${vaccinationList[index]["long"].toString()}";
                      print(
                          "https://www.google.com//maps/@${vaccinationList[index]["lat"]},${vaccinationList[index]["long"]}");
                      if (await canLaunch(googleMapsurl)) {
                        await launch(googleMapsurl);
                      } else {
                        throw "Coludn't launch Url";
                      }
                    },
                    color: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      "Navigate To Center",
                      style: TextStyle(
                          color: Colors.white, fontFamily: "OpenSans"),
                    ),
                  ),
                )
              ],
            )*/
          ]),
        ),
      ),
    );
  }

  ContainerNL(text, value) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.blueGrey[100]),
          borderRadius: BorderRadius.circular(30.0)),
      child: Padding(
        padding: EdgeInsets.only(left: 10.0),
        child: Row(children: [
          Text(
            text,
            style:
                TextStyle(fontFamily: "OpenSans", fontWeight: FontWeight.bold),
          ),
          Padding(padding: EdgeInsets.only(left: 10.0)),
          Container(
            width: 170,
            child: Text(
              value,
              style: TextStyle(fontFamily: "OpenSans"),
            ),
          ),
        ]),
      ),
    );
  }
}
