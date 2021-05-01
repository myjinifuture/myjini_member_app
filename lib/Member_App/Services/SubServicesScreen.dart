import 'dart:io';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/animation.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart';
import 'package:smart_society_new/Member_App/Services/ServiceList.dart';

class SubServicesScreen extends StatefulWidget {
  var ServiceData, Id;

  SubServicesScreen(this.ServiceData, this.Id,);

  @override
  _SubServicesScreenState createState() => _SubServicesScreenState();
}

class _SubServicesScreenState extends State<SubServicesScreen> {
  bool isLoading = false;
  List ServiceData = new List();
  List subCategoryList = [];

  @override
  void initState() {
    print("Meher=> "+widget.ServiceData);
    _ServiceData();
    _getSubCategory();
    print("Helooo => " + widget.Id.toString());
  }

  _getSubCategory() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        String ServiceId = widget.Id;
        Future res = Services.GetSubCategory(ServiceId);
        setState(() {
          isLoading = true;
        });
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              subCategoryList = data;
              isLoading = false;
            });
          } else {
            setState(() {
              subCategoryList = [];
              isLoading = false;
            });
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          print("Error : on NewLead Data Call $e");
          showMsg("$e");
        });
      } else {
        showMsg("Something went Wrong!");
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  _ServiceData() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });

        Services.GetServices().then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data != null && data.length > 0) {
            setState(() {
              ServiceData = data;
              print(data);
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
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
              },
            ),
          ],
        );
      },
    );
  }

  Widget _getServiceMenu(BuildContext context, int index) {
    return AnimationConfiguration.staggeredGrid(
      position: index,
      columnCount: 4,
      duration: const Duration(milliseconds: 375),
      child: SlideAnimation(
        verticalOffset: 100,
        child: ScaleAnimation(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ServiceList(
                    subCategoryList[index],
                    widget.Id,
                    widget.ServiceData
                  ),
                ),
              );
            },
            child: Card(
              elevation: 1,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 8, left: 4, right: 4, bottom: 4),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        FadeInImage.assetNetwork(
                            placeholder: "images/placeholder.png",
                            image: Image_Url +
                                '${subCategoryList[index]["Image"]}',
                            width: 35,
                            height: 35),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 3),
                            child: Text(
                              '${subCategoryList[index]["Title"]}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  final _imageUrls = [
    "http://cashkaro.com/blog/wp-content/uploads/sites/5/2018/03/Housejoy-AC-Service-Offer.gif",
    "https://www.cleaningbyrosie.com/wp-content/uploads/2016/12/facebook-cover2-630x315.jpg",
    "https://i.ytimg.com/vi/FTguamlXGWs/maxresdefault.jpg"
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },),
          centerTitle: true,
          title: Text(
            '${widget.ServiceData}',
            style: TextStyle(fontSize: 18),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(10),
            ),
          ),
        ),
        body: Container(
          color: Colors.grey[100],
          child: Column(
            children: <Widget>[
              Container(
                  child: CarouselSlider(
                height: 115,
                // aspectRatio: 16/5,
                viewportFraction: 0.8,
                initialPage: 0,
                // enlargeCenterPage: true,
                reverse: false,
                autoPlayCurve: Curves.fastOutSlowIn,
                autoPlay: true,
                items: _imageUrls.map((i) {
                  return Builder(builder: (BuildContext context) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, left: 4.0, right: 4.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: FadeInImage.assetNetwork(
                          placeholder: "images/placeholder.png",
                          image: '$i',
                          fit: BoxFit.fill,
                        ),
                      ),
                    );
                  });
                }).toList(),
              )),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Container(
                      child: isLoading
                          ? Container(
                              child: Center(child: CircularProgressIndicator()),
                            )
                          : subCategoryList.length > 0
                              ? GridView.builder(
                                  shrinkWrap: true,
                                  itemCount: subCategoryList.length,
                                  itemBuilder: _getServiceMenu,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
//                                childAspectRatio: MediaQuery.of(context)
//                                        .size
//                                        .width /
//                                    (MediaQuery.of(context).size.height /1.8),
                                  ))
                              : Center(
                                  child: Text(
                                  "No Data Found",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18),
                                ))),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
