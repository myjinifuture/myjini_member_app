import 'dart:io';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/animation.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';

import 'package:smart_society_new/Member_App/Services/ServiceList.dart';
import 'package:easy_gradient_text/easy_gradient_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:smart_society_new/Member_App/common/constant.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;
import 'package:smart_society_new/Member_App/screens/RateVendorScreen.dart';
import 'package:smart_society_new/Member_App/screens/StaffReviewListingScreen.dart';
import 'package:intl/intl.dart';
import '../common/Services1.dart';
import '../screens/VendorRequest.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';


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

  TextEditingController _txtdescription = TextEditingController();
  bool isLoading = false;
  List ServiceData = new List();
  List subCategoryList = [];
  List otherVendorData = [];
  List societyVendorDetails = [];
  List Time = ["7:00am","7:30am"];

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

  DateTime selectedDate = DateTime.now();

  vendorRequest(id,int index,DateTime date,String description) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var categoryId = prefs.getString(Session.VendorCateId);
      var memId = prefs.getString(Session.Member_Id);
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var body = {
          "memberId": memId,
          "memberTime": index,
          "date": DateFormat('dd/MM/yyyy').format(date),
          "description": description,
          "vendorCategoryId":categoryId,
          "vendorId": id
        };
        print(body);
        setState(() {
          isLoading = true;
        });
        Services.responseHandler(apiName: "member/addVendorDate", body: body)
            .then((data) async {
          if (data.Data != null) {
            setState(() {
              print(data.Data);
              Fluttertoast.showToast(
                  msg: "Request Successfully..!!",
                  backgroundColor: Colors.green,
                  gravity: ToastGravity.TOP,
                  textColor: Colors.white);
              Navigator.pop(context);
            });
          } else if (data.Data.toString() == "0") {
            setState(() {
              Fluttertoast.showToast(
                  msg: "Vendor Rejected!!!",
                  backgroundColor: Colors.red,
                  gravity: ToastGravity.TOP,
                  textColor: Colors.white);
              isLoading = false;
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

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime.now(),
      lastDate: DateTime(30000),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
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


  var _index = 0;

  @override
  Widget build(BuildContext context) {
    print("otherVendorData");
    print(otherVendorData);
    return Scaffold(
      appBar: AppBar(
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
                    child: otherVendorData.length > 0
                            ? ListView.builder(
                                physics: BouncingScrollPhysics(),
                                 shrinkWrap: true,
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
                                                              otherVendorId: otherVendorData[index]["_id"],
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
                                              RaisedButton(
                                                onPressed: () {
                                                    var Id =otherVendorData[index]["_id"];
                                                  //Navigator.push(context, MaterialPageRoute(builder: (context)=>VendorRequest()));
                                                    AlertDialogopen(Id);
                                                },
                                                child: Text("Request",
                                                    style: TextStyle(
                                                        fontFamily:
                                                        "OpenSans",
                                                        color:
                                                        Colors.white)),
                                                color: Colors.deepPurple,
                                                shape:
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(
                                                        8)),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    right: 10.0),
                                              )
                                             /* IconButton(
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
                                              ),*/
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
  AlertDialogopen(String id) {
    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
                opacity: a1.value,
                child: AlertDialog(
                  backgroundColor: Colors.white,
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0)),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Vendor Request",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 80.0),
                      ),
                      InkWell(
                        child: Icon(
                          Icons.close_sharp,
                          color: Colors.black,
                          size: 20.0,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  content: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                        children: [
                     Row(
                        children: [
                          IconButton(
                            icon: Image.asset("assets/image/calender.png"),
                            onPressed: () {
                              _selectDate(context);
                            },
                          ),
                          Text(
                            DateFormat('dd/MM/yyyy').format(selectedDate),
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                          /*CalendarTimeline(
                            firstDate: DateTime.now(),
                            initialDate: selectedDate,
                            lastDate: DateTime.now().add(Duration(days: 365)),
                            onDateSelected: (date) {
                              selectedDate = date;
                              print(selectedDate);
                            },
                            monthColor: Colors.transparent,
                            dayColor: Colors.deepPurple,
                            dotsColor: Colors.transparent,
                            activeDayColor: Colors.purple,
                            activeBackgroundDayColor: Colors.grey[200],
                            selectableDayPredicate: (date) => date.weekday != 7,
                          ),*/
                          Padding(padding: EdgeInsets.only(top:10.0)),
                          Container(
                              height: 100,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: Colors.deepPurple[200],
                              ),
                              child: CupertinoPicker(
                                itemExtent: 50,
                                onSelectedItemChanged: (value) {
                                  setState(() {
                                    _index = value;
                                    print("print _index value......");
                                    print(_index);
                                  });
                                },
                                children:[

                                  textTime("8:00am"),
                                  textTime("8:30am"),
                                  textTime("9:00am"),
                                  textTime("9:30am"),
                                  textTime("10:00am"),
                                  textTime("10:30am"),
                                  textTime("11:00am"),
                                  textTime("11:30am"),
                                  textTime("12:00pm"),
                                  textTime("12:30pm"),
                                  textTime("1:00pm"),
                                  textTime("1:30pm"),
                                ],
                              )),
                          Padding(padding: EdgeInsets.only(top:20.0)),
                      TextFormField(
                          controller: _txtdescription,
                          maxLines: 2,
                          decoration: InputDecoration(
                            hintText: "Description",
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          )),
                      // ignore: deprecated_member_use
                      RaisedButton(
                        onPressed: () {
                          setState(() {
                            vendorRequest(id,_index,selectedDate,_txtdescription.text);
                          });
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        color: Colors.deepPurple,
                        child: Text(
                          "Submit",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                    ]),
                  ),
                )),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: false,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return Column(
            children: [],
          );
        });
  }

  textTime(text){
    return Text(text,style : TextStyle(fontSize: 24,
        color:Colors.black ));
  }
}
