import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:io';
import 'package:smart_society_new/Member_App/common/vaccinationServices.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';

class VaccinationCenter extends StatefulWidget {
  @override
  _VaccinationCenterState createState() => _VaccinationCenterState();
}

class _VaccinationCenterState extends State<VaccinationCenter> {
  TextEditingController _txtDistrictSearch = TextEditingController();
  TextEditingController _txtPincodeSearch = TextEditingController();

  List vaccinationList = [];
  List filtredDistrictList = [];
  List filtredPincodeList = [];

  bool isPincode = true;
  bool isDistrict = false;

  bool isSearch = false;
  var latitude;
  var longitude;
  String vaccineUrl = "";

  double totalDistance = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentLocation();
  }

  void getCurrentLocation() async {
    var answer = await Geolocator.getCurrentPosition();
    setState(() {
      latitude = answer.latitude.toString();
      longitude = answer.longitude.toString();
      vaccineUrl =
          "https://cdn-api.co-vin.in/api/v2/appointment/centers/public/findByLatLong?"
          "lat=${latitude}&long=${longitude}";
    });
    getallvaccinationData(vaccineUrl);
  }

  calculateDistance(latitude, longitude, lat2, lon2) {
    var lat2 = double.parse(vaccinationList[0]["lat"]);
    var log2 = double.parse(vaccinationList[0]["long"]);
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - latitude) * p) / 2 +
        c(latitude * p) * c(lat2 * p) * (1 - c((lon2 - longitude) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  getallvaccinationData(String url) async {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      var body = {};

      VaccinationServices.responseHandler(apiName: url, body: body).then(
          (data) async {
        if (data.centers.length > 0) {
          setState(() {
            vaccinationList = data.centers;
            filtredDistrictList = data.centers;
            filtredPincodeList = data.centers;
          });
        }
      }, onError: (e) {
        //  showMsg("$e");
      });
    }
  }

  filteredDistrict(String value) {
    setState(() {
      filtredDistrictList = vaccinationList
          .where((name) => name["district_name"]
              .toString()
              .toLowerCase()
              .contains(value.toString().toLowerCase()))
          .toList();
    });
  }

  filteredPincode(String value) {
    setState(() {
      filtredPincodeList = vaccinationList
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
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              vaccinationList.length > 0 ? SerchingUI() : Container(),
              Padding(padding: EdgeInsets.only(top: 10.0)),
              vaccinationList.length > 0 ? searchBar() : Container(),
              vaccinationList.length > 0
                  ? isPincode
                      ? filtredPincodeList.length > 0
                          ? ListView.builder(
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: filtredPincodeList.length,
                              itemBuilder: (context, index) =>
                                  isPincode ? listviewPincodedata(index) : null)
                          : Column(children: [
                              Padding(padding: EdgeInsets.only(top: 150.0)),
                              CircularProgressIndicator()
                            ])
                      : filtredDistrictList.length > 0
                          ? ListView.builder(
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: filtredDistrictList.length,
                              itemBuilder: (context, index) => isDistrict
                                  ? listviewDistrictdata(index)
                                  : null,
                            )
                          : Column(
                              children: [
                                Padding(padding: EdgeInsets.only(top: 150.0)),
                                CircularProgressIndicator(),
                              ],
                            )
                  : Center(
                      child: Container(
                          margin: EdgeInsets.only(top: 250),
                          child: Lottie.asset("assets/json/splash_loader.json",
                              width: 100, height: 100)),
                    )
            ],
          ),
        ));
  }

  searchBar() {
    return Row(
      children: [
        Padding(padding: EdgeInsets.only(left: 15.0)),
        !isSearch
            ? Row(
                children: [
                  isPincode
                      ? Text(
                          "Search By Pincode",
                          style:
                              TextStyle(fontSize: 16, fontFamily: "OpenSans"),
                        )
                      : Text(
                          "Search By District...",
                          style:
                              TextStyle(fontSize: 16, fontFamily: "OpenSans"),
                        ),
                  Padding(padding: EdgeInsets.only(left: 140))
                ],
              )
            : Container(
                width: 285,
                child: isPincode
                    ? TextField(
                        controller: _txtPincodeSearch,
                        onChanged: filteredPincode,
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
                      )
                    : TextField(
                        controller: _txtDistrictSearch,
                        onChanged: filteredDistrict,
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
                      ),
              ),
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

  SerchingUI() {
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
  }

  listviewDistrictdata(index) {
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
            Padding(padding: const EdgeInsets.only(top: 10.0)),
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
                      var googleMapsurl =
                          "comgooglemaps://?center=${filtredDistrictList[index]["lat"]},${filtredDistrictList[index]["long"]}";
                      var appleMapUrl =
                          "https://maps.apple.com/?q=${filtredDistrictList[index]["lat"]},${filtredDistrictList[index]["long"]}";
                      if (await canLaunch(googleMapsurl)) {
                        await launch(googleMapsurl);
                      }
                      if (await canLaunch(appleMapUrl)) {
                        await launch(appleMapUrl, forceSafariVC: false);
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
            )
          ]),
        ),
      ),
    );
  }

  listviewPincodedata(index) {
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
                    "Center Name   :", filtredPincodeList[index]["name"]),
              ],
            ),
            Padding(padding: const EdgeInsets.only(top: 10.0)),
            Row(
              children: [
                ContainerUI("District              :",
                    filtredPincodeList[index]["district_name"]),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 10.0)),
            Row(
              children: [
                ContainerNL("Location            :",
                    filtredPincodeList[index]["location"]),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 10.0)),
            Row(
              children: [
                ContainerUI("PinCode             :",
                    filtredPincodeList[index]["pincode"]),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 10.0)),
            Row(
              children: [
                ContainerUI("block                  :",
                    filtredPincodeList[index]["block_name"]),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 10.0)),
            Row(
              children: [
                ContainerUI("Near By             :",
                    "${num.parse(calculateDistance(double.parse(latitude), double.parse(longitude), double.parse(filtredPincodeList[index]["lat"]), double.parse(filtredPincodeList[index]["long"])).toString()).toStringAsFixed(2)} km"),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 10.0)),
            Row(
              children: [
                Expanded(
                  child: RaisedButton(
                    onPressed: () async {
                      var googleMapsurl =
                          "comgooglemaps://?center=${filtredPincodeList[index]["lat"]},${filtredPincodeList[index]["long"]}";
                      var appleMapUrl =
                          "https://maps.apple.com/?q=${filtredPincodeList[index]["lat"]},${filtredPincodeList[index]["long"]}";
                      if (await canLaunch(googleMapsurl)) {
                        await launch(googleMapsurl);
                      }
                      if (await canLaunch(appleMapUrl)) {
                        await launch(appleMapUrl, forceSafariVC: false);
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
            )
          ]),
        ),
      ),
    );
  }

  ContainerUI(text, value) {
    return Container(
      width: MediaQuery.of(context).size.width - 50,
      height: 40,
      decoration: BoxDecoration(
          color: Colors.grey[50],
          border: Border.all(color: Colors.blueGrey[100]),
          borderRadius: BorderRadius.circular(30.0)),
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Row(children: [
          Text(
            text,
            style:
                TextStyle(fontFamily: "OpenSans", fontWeight: FontWeight.bold),
          ),
          Padding(padding: const EdgeInsets.only(left: 10.0)),
          Text(
            value,
            style: TextStyle(fontFamily: "OpenSans"),
          ),
        ]),
      ),
    );
  }

  ContainerNL(text, value) {
    return Container(
      width: MediaQuery.of(context).size.width - 50,
      height: 40,
      decoration: BoxDecoration(
          color: Colors.grey[50],
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
