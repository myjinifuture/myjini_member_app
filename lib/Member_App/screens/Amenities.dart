import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Admin_App/Component/LoadingComponent.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;
import 'package:smart_society_new/Admin_App/Common/Constants.dart' as cnst;

class Amenities extends StatefulWidget {
  @override
  _AmenitiesState createState() => _AmenitiesState();
}

class _AmenitiesState extends State<Amenities> {
  List _aminitiesData = new List();
  bool isLoading = false;

  @override
  void initState() {
    _getLocalData(); // ask monil to give me amenities api - 11 number
  }

  String societyId;

  _getLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    societyId = prefs.getString(Session.SocietyId);
    _getAmenities();
  }

  _getAmenities() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        var data = {"societyId": societyId};
        print("called");
        print(data);
        Services.responseHandler(
                apiName: "admin/getAllSocietyAmeties", body: data)
            .then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data.Data != null && data.Data.length > 0) {
            setState(() {
              _aminitiesData = data.Data;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          'Amenities',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,

        // leading: IconButton(
        //   icon: Icon(
        //     Icons.arrow_back,
        //     color: Colors.white,
        //   ),
        //   onPressed: () {
        //     Navigator.pushReplacementNamed(context, "/HomeScreen");
        //   },
        // ),
      ),
      body: isLoading
          ? LoadingComponent()
          : _aminitiesData.length > 0
              ? Container(
                  child: Swiper(
                    itemBuilder: (BuildContext, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            FadeInImage.assetNetwork(
                              placeholder: "images/placeholder.png",
                              image: _aminitiesData[index]["images"].length ==
                                      0
                                  ? ""
                                  : Image_Url +
                                      '${_aminitiesData[index]["images"][0]}',
                              width: MediaQuery.of(context).size.width,
                              height: 200,
                            ),
                            Padding(padding: EdgeInsets.only(top: 15)),
                            Text(
                              "${_aminitiesData[index]["amenityName"]}",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: constant.appPrimaryMaterialColor,
                                  fontWeight: FontWeight.w600),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 17.0, left: 30, right: 30),
                              /*child: Text(
                                "A swimming pool, swimming bath, wading pool, paddling pool, or simply pool is a structure designed to hold water to enable swimming or other leisure activities",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: constant.appprimarycolors[400],
                                ),
                              ),*/
                            ),
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 12.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    _aminitiesData[index]["isPaid"] == true
                                        ? Text("Paid",
                                            style: TextStyle(
                                                color: Colors.orange,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700))
                                        : Text("Free",
                                            style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700)),
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Icon(Icons.verified_user,
                                          size: 18,
                                          color: _aminitiesData[index]
                                                      ["isPaid"] ==
                                                  true
                                              ? Colors.green
                                              : Colors.orange),
                                    )
                                  ],
                                ),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    new Radius.circular(10.0)),
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '₹${_aminitiesData[index]["Amount"].toString()}',
                                ),
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: _aminitiesData[index]["description"] ==
                                            "" ||
                                        _aminitiesData[index]
                                                ["description"] ==
                                            null
                                    ? Container()
                                    : Text(
                                        _aminitiesData[index]["description"],
                                      ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 25),
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    "Available Timing",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  Text(
                                    "${_aminitiesData[index]["fromTime"]}" +
                                        " - " +
                                        "${_aminitiesData[index]["toTime"]}",
                                    style: TextStyle(color: Colors.black),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    itemCount: _aminitiesData.length,
                    pagination: new SwiperPagination(
                        builder: DotSwiperPaginationBuilder(
                      color: Colors.grey[400],
                    )),
//                      control: new SwiperControl(size: 17),
                  ),
                )
              : Container(
                  child: Center(child: Text("No Data Found")),
                ),
    );
  }
}
