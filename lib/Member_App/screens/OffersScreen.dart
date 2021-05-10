import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:smart_society_new/Member_App/screens/OffersListingScreen.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smart_society_new/Member_App/screens/BannerScreen.dart';
import '../screens/AdDetailPage.dart';
import 'package:smart_society_new/Member_App/common/constant.dart';

class OffersScreen extends StatefulWidget {
  const OffersScreen({Key key}) : super(key: key);

  @override
  _OffersScreenState createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  List _advertisementData = [];
  List banners = [];

  bool isLoading = true;
  int _current = 0;
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  void initState() {
    getAdvertisementData();
    getBanner();
  }

  getAdvertisementData() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var data = {
          // "societyId": SocietyId,
        };

        setState(() {
          isLoading = true;
        });
        Services.responseHandler(apiName: "member/getAdvertisement", body: data)
            .then((data) async {
          print("data");
          print(data.Data);
          if (data.Data != null && data.Data.length > 0) {
            setState(() {
              _advertisementData = data.Data;
              isLoading = false;
            });
            print("_advertisementData");
            print(_advertisementData);
          } else {
            setState(() {
              isLoading = false;
              // _advertisementData = data.Data;
            });
          }
        }, onError: (e) {
          showMsg("Something Went Wrong.\nPlease Try Again");
          setState(() {
            isLoading = false;
          });
        });
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  getBanner() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        Services.responseHandler(apiName: "admin/getBanner", body: {}).then(
                (data) async {
              if (data.Data != null && data.Data.length > 0) {
                setState(() {
                  banners = data.Data;
                  isLoading = false;
                });
              } else {
                setState(() {
                  isLoading = false;
                  banners = data.Data;
                });
              }
            }, onError: (e) {
          showMsg("Something Went Wrong.\nPlease Try Again");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Offers & Deals'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _advertisementData.length > 0
              ? GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BannerScreen(
                    bannerData: _advertisementData,
                  ),
                ),
              );
            },
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                _advertisementData.length == 0
                    ? CircularProgressIndicator()
                    : CarouselSlider(
                  height: MediaQuery.of(context)
                      .size
                      .height *
                      0.218,
                  viewportFraction: 1.0,
                  autoPlayAnimationDuration:
                  Duration(milliseconds: 1000),
                  reverse: false,
                  autoPlayCurve:
                  Curves.fastOutSlowIn,
                  autoPlay: true,
                  onPageChanged: (index) {
                    setState(() {
                      _current = index;
                    });
                  },
                  items:
                  _advertisementData.map((i) {
                    return Builder(builder:
                        (BuildContext context) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AdDetailPage(
                                    data: i,
                                  ),
                            ),
                          );
                        },
                        child: Container(
                            width: MediaQuery.of(
                                context)
                                .size
                                .width,
                            child: Image.network(
                                Image_Url +
                                    i["Image"][0],
                                fit: BoxFit.fill)),
                      );
                    });
                  }).toList(),
                ),

                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: map<Widget>(
                    _advertisementData,
                        (index, url) {
                      return Container(
                        width: 7.0,
                        height: 7.0,
                        margin: EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 2.0),
                        decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.all(
                                Radius.circular(5)),
                            color: _current == index
                                ? Colors.white
                                : Colors.grey),
                      );
                    },
                  ),
                ),
              ],
            ),
          )
              : banners.length == 0
              ? Center(
            child: CircularProgressIndicator(),
          )
              : CarouselSlider(
            height: 180,
            viewportFraction: 1.0,
            autoPlayAnimationDuration:
            Duration(milliseconds: 1000),
            reverse: false,
            autoPlayCurve: Curves.fastOutSlowIn,
            autoPlay: true,
            onPageChanged: (index) {
              setState(() {
                _current = index;
              });
            },
            items: banners.map((i) {
              return Builder(
                  builder: (BuildContext context) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AdDetailPage(
                                  data: i,
                                ),
                          ),
                        );
                      },
                      child: Container(
                          width: MediaQuery.of(context)
                              .size
                              .width,
                          child: Image.network(
                              Image_Url + i["image"],
                              fit: BoxFit.fill)),
                    );
                  });
            }).toList(),
          ),
          AnimationLimiter(
            child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1,
              ),
              itemCount: 8,
              itemBuilder: (BuildContext context, int index) =>
                  AnimationConfiguration.staggeredGrid(
                position: index,
                duration: const Duration(milliseconds: 375),
                columnCount: 4,
                child: SlideAnimation(
                  child: ScaleAnimation(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OffersListingScreen(),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                              //  bottom: BorderSide(width: ,color: Colors.black54),
                              top: BorderSide(width: 0.2, color: Colors.black)),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                  width: 0.2, color: Colors.grey[600]),
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                    width: 0.2, color: Colors.grey[600]),
                              ),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                      width: 0.2, color: Colors.grey[600]),
                                ),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset(
                                      "images/deals.png",
                                      width: 25,
                                      height: 25,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Text(
                                        'Demo',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 11, color: Colors.black),
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
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
