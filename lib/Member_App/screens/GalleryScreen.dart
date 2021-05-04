import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Admin_App/Component/LoadingComponent.dart';
import 'package:smart_society_new/Admin_App/Component/NoDataComponent.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;
import 'package:smart_society_new/Member_App/common/constant.dart';
import 'package:smart_society_new/Member_App/screens/Single_Events_Allphoto.dart';

import 'AllImagesInGallery.dart';

class GalleryScreen extends StatefulWidget {
  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  List EventData = [];
  bool isLoading = true;
  String SocietyId;

  @override
  void initState() {
    GetGallaryData(); // ask monil to make events api 10 - number
    _getLocaldata();
  }

  _getLocaldata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SocietyId = prefs.getString(constant.Session.SocietyId);
  }

  GetGallaryData() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var data = {
          "societyId": SocietyId
        };
        Services.responseHandler(apiName: "admin/getGallery",body: data).then((data) async {
          setState(() {
            isLoading = false;
          });
          await prefs.setString(
              constant.Session.EventId, data.Data[0]["_id"].toString());

          if (data.Data != null && data.Data.length > 0) {
            setState(() {
              EventData = data.Data;
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

  Widget _EventFolder(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventPhotos(EventData[index]),
          ),
        );
      },
      child: Padding(
        padding:
            const EdgeInsets.only(left: 8.0, right: 8.0, top: 6, bottom: 3),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(6.0)),
          child: Container(
            height: 130,
            child: Stack(children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                child: FadeInImage.assetNetwork(
                  placeholder: "images/placeholder.png",
                  image: Image_Url + '${EventData[index]["Image"][0]}',
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromRGBO(0, 0, 0, 0.0),
                        Color.fromRGBO(0, 0, 0, 0.5),
                        Color.fromRGBO(0, 0, 0, 0.7),
                        Color.fromRGBO(0, 0, 0, 1)
                      ]),
                ),
              ),
              Container(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text('${EventData[index]["title"]}',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16)),
                    Text("${EventData[index]["image"].length} Photos",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 16)),
                  ],
                ),
              ))
            ]),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacementNamed(context, '/HomeScreen');
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushReplacementNamed(context, "/HomeScreen");
              }),
          centerTitle: true,
          title: Text(
            'Gallery',
            style: TextStyle(fontSize: 18),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(10),
            ),
          ),
        ),
        body: isLoading
            ? LoadingComponent()
            : EventData.length > 0
            ? Container(
            color: Colors.grey[100],
            child: AnimationLimiter(
              child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  print(Image_Url + EventData[index]["image"][0]);
                  print(EventData);
                  return Padding(
                    padding: const EdgeInsets.only(bottom:16.0),
                    child: AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 475),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: GestureDetector(
                            // onTap: () { // ANIRUDH HAS DOUBT
                            //   Navigator.pushReplacement(
                            //       context,
                            //       MaterialPageRoute(
                            //           builder: (context) => EventGallary(
                            //                 eventId:
                            //                     "${_galleryData[index]["_id"].toString()}",
                            //               )));
                            // },
                            child: Padding(
                              padding: const EdgeInsets.all(7),
                              child:
                              Container(
                                height: 170,
                                child: Stack(children: <Widget>[
                                  // _galleryData[index]["image"].length >0
                                  //
                                  //     ?
                                  CarouselSlider(
                                    height: 180,
                                    viewportFraction: 1.0,
                                    autoPlayAnimationDuration: Duration(milliseconds: 1000),
                                    reverse: false,
                                    autoPlayCurve: Curves.fastOutSlowIn,
                                    autoPlay: true,
                                    items: EventData[index]["image"].map<Widget>((i) {
                                      return Builder(builder: (BuildContext context) {
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AllImagesInGallery(data:EventData[index]),
                                              ),
                                            );
                                          },
                                          child: Container(
                                              width: MediaQuery.of(context).size.width,
                                              child: Image.network(
                                                  Image_Url + i,
                                                  fit: BoxFit.fill)),
                                        );
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
                                                '${EventData[index]["title"]}',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                    FontWeight.w700,
                                                    fontSize: 16)),
                                            Text(
                                                "${EventData[index]["dateTime"][0]}",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                    FontWeight.w400,
                                                    fontSize: 16)),
                                          ],
                                        ),
                                      )),
                                ]),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: EventData.length,
              ),
            ))
            : NoDataComponent(),
      ),
    );
  }
}
