import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Admin_App/Component/LoadingComponent.dart';
import 'package:smart_society_new/Admin_App/Component/NoDataComponent.dart';
import 'package:smart_society_new/Admin_App/Common/Constants.dart' as cnst;
import 'package:smart_society_new/Admin_App/Screens/EditGallery.dart';
import 'package:smart_society_new/Admin_App/Screens/EventGallary.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart';
import '../Common/Constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_society_new/Admin_App/Screens/ViewGalleryPhotos.dart';

class Gallary extends StatefulWidget {
  @override
  _GallaryState createState() => _GallaryState();
}

class _GallaryState extends State<Gallary> {
  List _galleryData = [];
  bool isLoading = false;

  @override
  void initState() {
    getLocaldata();
  }

  String societyId = "";

  getLocaldata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      societyId = prefs.getString(cnst.Session.SocietyId);
    });
    _getGalleryDetails();
  }

  _getGalleryDetails() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var data = {"societyId": societyId};

        setState(() {
          isLoading = true;
        });
        Future res =
            Services.responseHandler(apiName: "admin/getGallery", body: data);
        res.then((data) async {
          if (data.Data != null && data.Data.length > 0) {
            setState(() {
              _galleryData = data.Data;
              isLoading = false;
            });
          } else {
            setState(() {
              isLoading = false;
              _galleryData = data.Data;
            });
          }
        }, onError: (e) {
          showMsg("Something Went Wrong Please Try Again");
          setState(() {
            isLoading = false;
          });
        });
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  deleteGallery(String galleryId) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        var data = {
          "galleryId": galleryId,
        };

        Services.responseHandler(apiName: "admin/deleteGallery", body: data)
            .then((data) async {
          print("gallery response");
          print(data);
          if (data.IsSuccess == true && data.Data.toString() == '1') {
            Fluttertoast.showToast(
                msg: "Gallery Deleted Successfully !!!",
                backgroundColor: Colors.green,
                gravity: ToastGravity.TOP);
            setState(() {
              isLoading = false;
              _getGalleryDetails();
            });
          } else {
            setState(() {
              isLoading = false;
            });
          }
        }, onError: (e) {
          showMsg("Something Went Wrong Please Try Again");
          setState(() {
            isLoading = false;
          });
        });
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
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
              child: new Text("Okay"),
              onPressed: () {
                Navigator.of(context).pop();
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
    }
    final_date = date == "" || date == null
        ? ""
        : "${tempDate[2].toString().substring(0, 2)}-${tempDate[1].toString()}-${tempDate[0].toString()}"
            .toString();

    return final_date;
  }

  void _showConfirmDialog(String galleryId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("MYJINI"),
          content: new Text("Are You Sure You Want To Delete this Gallery ?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("No",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600)),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/Dashboard');              },
            ),
            new FlatButton(
              child: new Text("Yes",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600)),
              onPressed: () {
                deleteGallery(galleryId);
                Navigator.pushReplacementNamed(context, '/Dashboard');              },
            ),
          ],
        );
      },
    );
  }

  // _deleteEvent(eventId) async {
  //   try {
  //     final result = await InternetAddress.lookup('google.com');
  //     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
  //       setState(() {
  //         isLoading = true;
  //       });
  //       Services.DeleteEvent(eventId).then((data) async {
  //         if (data.Data == "1" && data.IsSuccess == true) {
  //           setState(() {
  //             isLoading = false;
  //           });
  //           _getEventData();
  //         } else {
  //           setState(() {
  //             isLoading = false;
  //           });
  //           showMsg("Event is Not Deleted..");
  //         }
  //       }, onError: (e) {
  //         setState(() {
  //           isLoading = false;
  //         });
  //         showMsg("Something Went Wrong Please Try Again");
  //       });
  //     }
  //   } on SocketException catch (_) {
  //     showMsg("Something Went Wrong");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacementNamed(context, '/Dashboard');
        },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Gallery",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/Dashboard');            },
          ),
        ),
        body: isLoading
            ? LoadingComponent()
            : _galleryData.length > 0
                ? Container(
                    color: Colors.grey[100],
                    child: AnimationLimiter(
                      child: ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          print(Image_Url + _galleryData[index]["image"][0]);
                          print(_galleryData);
                          return GestureDetector(
                            onTap: () {
                              print("gallery component clicked");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ViewGalleryPhotos(
                                    galleryData: _galleryData[index],onDelete: _getGalleryDetails,
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              child: AnimationConfiguration.staggeredList(
                                position: index,
                                duration: const Duration(milliseconds: 475),
                                child: SlideAnimation(
                                  verticalOffset: 50.0,
                                  child: FadeInAnimation(
                                    child: Padding(
                                      padding: const EdgeInsets.all(7),
                                      child: Container(
                                        height: 170,
                                        child: Stack(children: <Widget>[
                                          // _galleryData[index]["image"].length >0
                                          //
                                          //     ?
                                          CarouselSlider(
                                            height: 180,
                                            viewportFraction: 1.0,
                                            autoPlayAnimationDuration:
                                                Duration(milliseconds: 1000),
                                            reverse: false,
                                            autoPlayCurve: Curves.fastOutSlowIn,
                                            autoPlay: true,
                                            items: _galleryData[index]["image"]
                                                .map<Widget>((i) {
                                              return Builder(builder:
                                                  (BuildContext context) {
                                                return Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: Image.network(
                                                        Image_Url + i,
                                                        fit: BoxFit.fill));
                                              });
                                            }).toList(),
                                          ),
                                          // Image.network(
                                          //   Image_Url +
                                          //                  _galleryData[index]
                                          //                    ["image"][0],
                                          //   fit: BoxFit.fitWidth,
                                          //   width: MediaQuery.of(context).size.width,
                                          // height: 170,
                                          // ),FadeInImage.assetNetwork(
                                          //   placeholder: "",
                                          //   image:
                                          //   Image_Url +
                                          //           _galleryData[index]
                                          //               ["image"][0],
                                          //   width: MediaQuery.of(context)
                                          //       .size
                                          //       .width,
                                          //   fit: BoxFit.cover,
                                          // ),
                                          //       ),
                                          // : Image.asset(
                                          //     "images/no_image2.png",
                                          //     height: 130,
                                          //     width: MediaQuery.of(context)
                                          //         .size
                                          //         .width,
                                          //   ),
                                          // Container(
                                          //   decoration: BoxDecoration(
                                          //     gradient: LinearGradient(
                                          //         begin: Alignment.topCenter,
                                          //         end: Alignment.bottomCenter,
                                          //         colors: [
                                          //           Color.fromRGBO(0, 0, 0, 0.0),
                                          //           Color.fromRGBO(0, 0, 0, 0.5),
                                          //           Color.fromRGBO(0, 0, 0, 0.7),
                                          //           Color.fromRGBO(0, 0, 0, 1)
                                          //         ]),
                                          //   ),
                                          // ),
                                          Container(
                                              child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: <Widget>[
                                                Text(
                                                    '${_galleryData[index]["title"]}',
                                                    style: TextStyle(
                                                        // color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 16)),
                                                Text(
                                                    "${_galleryData[index]["dateTime"][0]}",
                                                    style: TextStyle(
                                                        // color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 16)),
                                              ],
                                            ),
                                          )),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          EditGallery(
                                                        galleryData:
                                                            _galleryData[index],
                                                        onEdit:
                                                            _getGalleryDetails,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 5, top: 5),
                                                  child: Align(
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: Card(
                                                      child: Image.asset(
                                                          "images/edit_icon.png",
                                                          width: 23,
                                                          height: 23,
                                                          fit: BoxFit.fill),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  _showConfirmDialog(
                                                      _galleryData[index]["_id"]
                                                          .toString());
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 5, top: 5),
                                                  child: Align(
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: Card(
                                                      child: Image.asset(
                                                          "images/delete_icon.png",
                                                          color: Colors.red,
                                                          width: 24,
                                                          height: 24,
                                                          fit: BoxFit.fill),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ]),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: _galleryData.length,
                      ),
                    ))
                : Center(
                    child: Text('No Data Found'),
                  ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/AddGallary');
          },
          child: Icon(Icons.add, color: Colors.white),
          backgroundColor: cnst.appPrimaryMaterialColor,
        ),
      ),
    );
  }
}
