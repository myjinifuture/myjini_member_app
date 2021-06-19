import 'dart:io';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/animation.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart';
import 'package:smart_society_new/Member_App/Services/ServiceList.dart';
import 'package:easy_gradient_text/easy_gradient_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;
import 'package:smart_society_new/Member_App/screens/RateVendorScreen.dart';
import 'package:smart_society_new/Member_App/screens/StaffReviewListingScreen.dart';

class SubServicesScreen extends StatefulWidget {
  var ServiceData, Id;

  SubServicesScreen(
    this.ServiceData,
    this.Id,
  );

  @override
  _SubServicesScreenState createState() => _SubServicesScreenState();
}

class _SubServicesScreenState extends State<SubServicesScreen> {
  bool isLoading = false;
  List ServiceData = new List();
  List subCategoryList = [];
  List otherVendorData = [];

  @override
  void initState() {
    print("Meher=> " + widget.ServiceData);
    getVendorCategoryWise();
    // _ServiceData();
    // _getSubCategory();
    print("Helooo => " + widget.Id.toString());
  }

  _openWhatsapp(mobile) {
    String whatsAppLink = constant.whatsAppLink;
    String urlwithmobile = whatsAppLink.replaceAll("#mobile", "91$mobile");
    String urlwithmsg = urlwithmobile.replaceAll("#msg", "");
    launch(urlwithmsg);
  }

  getVendorCategoryWise() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        var data = {
          "vendorCategoryId": widget.Id,
        };
        Services.responseHandler(
                apiName: "member/getVendorCategorywise", body: data)
            .then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data.Data != null && data.Data.length > 0) {
            setState(() {
              otherVendorData = data.Data;
              print(data.Data);
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

  // _getSubCategory() async {
  //   try {
  //     final result = await InternetAddress.lookup('google.com');
  //     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
  //       String ServiceId = widget.Id;
  //       Future res = Services.GetSubCategory(ServiceId);
  //       setState(() {
  //         isLoading = true;
  //       });
  //       res.then((data) async {
  //         if (data != null && data.length > 0) {
  //           setState(() {
  //             subCategoryList = data;
  //             isLoading = false;
  //           });
  //         } else {
  //           setState(() {
  //             subCategoryList = [];
  //             isLoading = false;
  //           });
  //         }
  //       }, onError: (e) {
  //         setState(() {
  //           isLoading = false;
  //         });
  //         print("Error : on NewLead Data Call $e");
  //         showMsg("$e");
  //       });
  //     } else {
  //       showMsg("Something went Wrong!");
  //     }
  //   } on SocketException catch (_) {
  //     showMsg("No Internet Connection.");
  //   }
  // }

  // _ServiceData() async {
  //   try {
  //     final result = await InternetAddress.lookup('google.com');
  //     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
  //       setState(() {
  //         isLoading = true;
  //       });
  //
  //       Services.GetServices().then((data) async {
  //         setState(() {
  //           isLoading = false;
  //         });
  //         if (data != null && data.length > 0) {
  //           setState(() {
  //             ServiceData = data;
  //             print(data);
  //           });
  //         } else {
  //           setState(() {
  //             isLoading = false;
  //           });
  //         }
  //       }, onError: (e) {
  //         setState(() {
  //           isLoading = false;
  //         });
  //         showHHMsg("Try Again.", "");
  //       });
  //     }
  //   } on SocketException catch (_) {
  //     showHHMsg("No Internet Connection.", "");
  //   }
  // }

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
                ;
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
                ;
              },
            ),
          ],
        );
      },
    );
  }

  // Widget _getServiceMenu(BuildContext context, int index) {
  //   return AnimationConfiguration.staggeredGrid(
  //     position: index,
  //     columnCount: 4,
  //     duration: const Duration(milliseconds: 375),
  //     child: SlideAnimation(
  //       verticalOffset: 100,
  //       child: ScaleAnimation(
  //         child: GestureDetector(
  //           onTap: () {
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) => ServiceList(
  //                     otherVendorData[index], widget.Id, widget.ServiceData),
  //               ),
  //             );
  //           },
  //           child: Card(
  //             elevation: 1,
  //             child: Container(
  //               child: Padding(
  //                 padding: const EdgeInsets.only(
  //                     top: 8, left: 4, right: 4, bottom: 4),
  //                 child: Center(
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.center,
  //                     children: <Widget>[
  //                       FadeInImage.assetNetwork(
  //                           placeholder: "images/placeholder.png",
  //                           image: Image_Url +
  //                               '${otherVendorData[index]["vendorImage"]}',
  //                           width: 35,
  //                           height: 35),
  //                       Expanded(
  //                         child: Padding(
  //                           padding: const EdgeInsets.only(top: 3),
  //                           child: Text(
  //                             '${otherVendorData[index]["ServiceName"]}',
  //                             textAlign: TextAlign.center,
  //                             style: TextStyle(
  //                                 fontSize: 10,
  //                                 color: Colors.black,
  //                                 fontWeight: FontWeight.w600),
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  final _imageUrls = [
    "http://cashkaro.com/blog/wp-content/uploads/sites/5/2018/03/Housejoy-AC-Service-Offer.gif",
    "https://www.cleaningbyrosie.com/wp-content/uploads/2016/12/facebook-cover2-630x315.jpg",
    "https://i.ytimg.com/vi/FTguamlXGWs/maxresdefault.jpg"
  ];

  @override
  Widget build(BuildContext context) {
    print("otherVendorData");
    print(otherVendorData);
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //     icon: Icon(Icons.arrow_back),
        //     onPressed: () {
        //       Navigator.pop(context);
        //     },),
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
            // Container(
            //     child: CarouselSlider(
            //   height: 115,
            //   // aspectRatio: 16/5,
            //   viewportFraction: 0.8,
            //   initialPage: 0,
            //   // enlargeCenterPage: true,
            //   reverse: false,
            //   autoPlayCurve: Curves.fastOutSlowIn,
            //   autoPlay: true,
            //   items: _imageUrls.map((i) {
            //     return Builder(builder: (BuildContext context) {
            //       return Padding(
            //         padding:
            //             const EdgeInsets.only(top: 10.0, left: 4.0, right: 4.0),
            //         child: Container(
            //           width: MediaQuery.of(context).size.width,
            //           child: FadeInImage.assetNetwork(
            //             placeholder: "images/placeholder.png",
            //             image: '$i',
            //             fit: BoxFit.fill,
            //           ),
            //         ),
            //       );
            //     });
            //   }).toList(),
            // )),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Container(
                    child: isLoading
                        ? Container(
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : otherVendorData.length > 0
                            ? ListView.builder(
                                physics: BouncingScrollPhysics(),
                                // shrinkWrap: true,
                                itemCount: otherVendorData.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            contentPadding: EdgeInsets.zero,
                                            content: Stack(
                                              children: [
                                                Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.13,
                                                  decoration: new BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topRight:
                                                          Radius.circular(10),
                                                      topLeft:
                                                          Radius.circular(10),
                                                    ),
                                                    gradient: new LinearGradient(
                                                        colors: [
                                                          Color(0xffDA44bb),
                                                          Color(0xff8921aa)
                                                        ],
                                                        begin:
                                                            const FractionalOffset(
                                                                0.0, 0.0),
                                                        end:
                                                            const FractionalOffset(
                                                                1.0, 0.0),
                                                        stops: [0.0, 1.0],
                                                        tileMode:
                                                            TileMode.clamp),
                                                  ),
                                                ),
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    SizedBox(
                                                      height: 15,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'Vendor Details',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 15,
                                                    ),
                                                    ClipOval(
                                                      child:
                                                              otherVendorData[
                                                                          index][
                                                                      "vendorImage"] !=
                                                                  ""
                                                          ? FadeInImage.assetNetwork(
                                                              placeholder: '',
                                                              image: Image_Url +
                                                                  "${otherVendorData[index]["vendorImage"]}",
                                                              width: 80,
                                                              height: 80,
                                                              fit: BoxFit.fill)
                                                          : Image.asset(
                                                              "images/user.png",
                                                              height: 80,
                                                              width: 80,
                                                            ),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      otherVendorData[index]
                                                          ["Name"],
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 20,
                                                        color: Colors.grey[700],
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          otherVendorData[index]
                                                              ["ContactNo"],
                                                          style: TextStyle(
                                                            // fontStyle: FontStyle
                                                            //     .italic,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors
                                                                .grey[600],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          otherVendorData[index]
                                                              ["CompanyName"],
                                                          style: TextStyle(
                                                            // fontStyle: FontStyle
                                                            //     .italic,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors
                                                                .grey[600],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    // Row(
                                                    //   mainAxisAlignment:
                                                    //   MainAxisAlignment
                                                    //       .center,
                                                    //   children: [
                                                    //     Text(
                                                    //      "Category : ",
                                                    //       style: TextStyle(
                                                    //         // fontStyle: FontStyle
                                                    //         //     .italic,
                                                    //         fontWeight:
                                                    //         FontWeight
                                                    //             .w500,
                                                    //         color:
                                                    //         Colors.grey,
                                                    //       ),
                                                    //     ),Text(
                                                    //       otherVendorData[
                                                    //       index][
                                                    //       "ServiceName"],
                                                    //       style: TextStyle(
                                                    //         // fontStyle: FontStyle
                                                    //         //     .italic,
                                                    //         fontWeight:
                                                    //         FontWeight
                                                    //             .w500,
                                                    //         color:
                                                    //         Colors.grey,
                                                    //       ),
                                                    //     ),
                                                    //   ],
                                                    // ),
                                                    SizedBox(
                                                      height: 15,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            otherVendorData[
                                                                    index]
                                                                ["Address"],
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              // fontStyle: FontStyle
                                                              //     .italic,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          otherVendorData[index]
                                                              ["emailId"],
                                                          style: TextStyle(
                                                            fontStyle: FontStyle
                                                                .italic,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    IconButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      icon: Icon(
                                                        Icons.close_rounded,
                                                      ),
                                                      color: Colors.white,
                                                    ),
                                                  ],
                                                ),
                                                otherVendorData[index]["AverageRating"]==null?Row():Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 65,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 15.0),
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            color: Colors.white,
                                                          ),
                                                          height: 25,
                                                          width: 60,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                otherVendorData[index]
                                                                ["AverageRating"].toString(),
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: constant
                                                                      .appPrimaryMaterialColor,
                                                                ),
                                                              ),
                                                              Icon(
                                                                Icons
                                                                    .star_rate_rounded,
                                                                color: Colors
                                                                    .amberAccent,
                                                                size: 20,
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                StaffReviewListingScreen(
                                                                  ratingsData:
                                                                  otherVendorData[index]
                                                                  [
                                                                  "VendorRatings"],
                                                                ),
                                                          ),
                                                        );},
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 15.0),
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            height: 25,
                                                            width: 60,
                                                            child: Center(
                                                              child: Text(
                                                                'View All',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 12,
                                                                  color: constant
                                                                      .appPrimaryMaterialColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Card(
                                      // color: cnst.appPrimaryMaterialColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: 10,
                                              ),
                                              ClipOval(
                                                child:
                                                        otherVendorData[index][
                                                                "vendorImage"] !=
                                                            ""
                                                    ? FadeInImage.assetNetwork(
                                                        placeholder: '',
                                                        image: Image_Url +
                                                            "${otherVendorData[index]["vendorImage"]}",
                                                        width: 60,
                                                        height: 60,
                                                        fit: BoxFit.fill)
                                                    : Image.asset(
                                                        "images/vendorDefault.png",
                                                        height: 60,
                                                        width: 60,
                                                      ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    GradientText(
                                                      text:
                                                          otherVendorData[index]
                                                              ["Name"],
                                                      colors: <Color>[
                                                        Color(0xffDA44bb),
                                                        Color(0xff8921aa)
                                                      ],
                                                      style: TextStyle(
                                                        fontSize: 20.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    GradientText(
                                                      text:
                                                          otherVendorData[index]
                                                              ["CompanyName"],
                                                      colors: <Color>[
                                                        Color(0xffDA44bb),
                                                        Color(0xff8921aa)
                                                      ],
                                                      style: TextStyle(
                                                        fontSize: 12.0,
                                                        // fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                RateVendorScreen(
                                                              type: 1,
                                                              otherVendorId:
                                                                  otherVendorData[
                                                                          index]
                                                                      ["_id"],
                                                              onAddOtherVendorReview:
                                                                  getVendorCategoryWise,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child: Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.35,
                                                        child: Card(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4),
                                                          ),
                                                          color:
                                                              Colors.red[100],
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              GradientText(
                                                                text:
                                                                    'RATE NOW',
                                                                colors: <Color>[
                                                                  Color(
                                                                      0xffDA44bb),
                                                                  Color(
                                                                      0xff8921aa)
                                                                ],
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                              Icon(
                                                                Icons
                                                                    .star_half_rounded,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              IconButton(
                                                icon: Image.asset(
                                                  "images/whatsapp.png",
                                                  width: 50,
                                                  height: 50,
                                                ),
                                                onPressed: () {
                                                  _openWhatsapp(
                                                      otherVendorData[index]
                                                          ["ContactNo"]);
                                                },
                                              ),
                                              IconButton(
                                                icon: Icon(
                                                  Icons.call,
                                                  color: Colors.green,
                                                ),
                                                onPressed: () {
                                                  launch(
                                                      "tel:${otherVendorData[index]["ContactNo"]}");
                                                },
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
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
    );
  }
}
