import 'dart:io';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/animation.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart';
import 'package:smart_society_new/Member_App/Services/ServiceList.dart';
import 'package:smart_society_new/Member_App/Services/SubServicesScreen.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as cnst;
import 'package:smart_society_new/Member_App/component/MyServiceRequestComponent.dart';
import 'package:easy_gradient_text/easy_gradient_text.dart';

class ServicesScreen extends StatefulWidget {
  var search;
  int initialIndex;

  ServicesScreen({this.search,this.initialIndex});

  @override
  _ServicesScreenState createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen>
    with TickerProviderStateMixin {
  bool isLoading = false;
  List ServiceData = [];
  TabController _tabController;
  List NewList = [];
  ProgressDialog pr;
  List societyVendorDetails = [];
  bool societyVendorsLoading = false;
  int index = 0;

  @override
  void initState() {
    getSocietyVendors();
    _ServiceData();
    _getMyLeadsList();
    _tabController = new TabController(vsync: this, length: 2,initialIndex: widget.initialIndex);
  }

  _getMyLeadsList() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        String MemberId = await preferences.getString(cnst.Session.Member_Id);
        Future res = Services.GetLeadsByMember(MemberId);
        setState(() {
          isLoading = true;
        });

        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              NewList = data;
              isLoading = false;
            });
            print("New123=> " + NewList.toString());
          } else {
            setState(() {
              NewList = [];
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

  _ServiceData() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });

        Services.responseHandler(
            apiName: "admin/getAllVendorCategory", body: {}).then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data.Data != null && data.Data.length > 0) {
            setState(() {
              ServiceData = data.Data;
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
              /*Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ServiceList(
                    ServiceData[index],
                  ),
                ),
              );*/
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubServicesScreen(
                    ServiceData[index]["vendorCategoryName"].toString(),
                    ServiceData[index]["_id"].toString(),
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
                            image: Image_Url + '${ServiceData[index]["image"]}',
                            width: 35,
                            height: 35),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 3),
                            child: Text(
                              '${ServiceData[index]["vendorCategoryName"]}',
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

  getSocietyVendors() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          societyVendorsLoading = true;
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String societyId = prefs.getString(cnst.Session.SocietyId);
        var data = {
          "societyId": societyId,
        };
        Services.responseHandler(apiName: "member/getVendors", body: data).then(
                (data) async {
              print("data");
              print(data.Data);
              if (data.Data != null && data.Data.length > 0) {
                setState(() {
                  if(widget.search!=null){
                    societyVendorsLoading = false;
                    for(int i=0;i<data.Data.length;i++){
                      data.Data[i]["ServiceNameFull"] = data.Data[i]["ServiceName"] + "ian";
                      if(data.Data[i]["ServiceName"].toString().toUpperCase().
                      contains(widget.search.toUpperCase())){
                        societyVendorDetails.add(data.Data[i]);
                      }
                    }
                  }
                  else{
                    societyVendorsLoading = false;
                    societyVendorDetails = data.Data;
                  }

                });
                // print("societyVendorDetails");
                // print(societyVendorDetails);
              } else {
                setState(() {
                  societyVendorsLoading = false;
                });
              }
            }, onError: (e) {
          showMsg("Something Went Wrong.\nPlease Try Again");
          setState(() {
            societyVendorsLoading = false;
          });
        });
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  final _imageUrls = [
    "http://cashkaro.com/blog/wp-content/uploads/sites/5/2018/03/Housejoy-AC-Service-Offer.gif",
    "https://www.cleaningbyrosie.com/wp-content/uploads/2016/12/facebook-cover2-630x315.jpg",
    "https://i.ytimg.com/vi/FTguamlXGWs/maxresdefault.jpg"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //     icon: Icon(Icons.arrow_back),
        //     onPressed: () {
        //       Navigator.of(context).pop();
        //     }),
        centerTitle: true,
        title: Text(
          'Vendor Services',
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
            TabBar(
              unselectedLabelColor: Colors.grey[500],
              indicatorColor: Colors.black,
              labelColor: Colors.black,
              controller: _tabController,
              tabs: [
                Tab(
                  child: Text(
                    "My Society",
                  ),
                ),
                Tab(
                  child: Text(
                    "Others",
                  ),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  // Column(
                  //   children: <Widget>[
                  //     isLoading
                  //         ? Center(child: CircularProgressIndicator())
                  //         : NewList.length > 0
                  //         ? Expanded(
                  //       child: Padding(
                  //         padding: const EdgeInsets.all(8.0),
                  //         child: ListView.builder(
                  //             itemCount: NewList.length,
                  //             physics: const BouncingScrollPhysics(),
                  //             itemBuilder: (BuildContext context, int index) {
                  //               return SingleChildScrollView(
                  //                   child: MyServiceRequestComponent(NewList[index]));
                  //             }),
                  //       ),
                  //     )
                  //         : Center(
                  //         child: Text(
                  //           "No Data Found",
                  //           style: TextStyle(
                  //               color: Colors.grey,
                  //               fontWeight: FontWeight.w500,
                  //               fontSize: 18),
                  //         ))
                  //   ],
                  // ),
                  societyVendorsLoading == false
                      ? societyVendorDetails.length > 0
                      ? Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          // shrinkWrap: true,
                          itemCount: societyVendorDetails.length,
                          itemBuilder:
                              (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                // showDialog(
                                //   barrierDismissible: false,
                                //   context: context,
                                //   builder: (BuildContext context) {
                                //     return AlertDialog(
                                //       backgroundColor: cnst
                                //           .appPrimaryMaterialColor,
                                //       title: Row(
                                //         children: [
                                //           Expanded(
                                //             child: Center(
                                //               child: Text(
                                //                 "Vendor Details",
                                //                 style: TextStyle(
                                //                   color: Colors
                                //                       .cyan[600],
                                //                   fontSize: 18,
                                //                   fontWeight:
                                //                       FontWeight
                                //                           .w600,
                                //                 ),
                                //               ),
                                //             ),
                                //           ),
                                //           GestureDetector(
                                //             onTap: () {
                                //               Navigator.pop(
                                //                   context);
                                //             },
                                //             child: Icon(
                                //               Icons.close,
                                //               color: Colors.white,
                                //             ),
                                //           ),
                                //         ],
                                //       ),
                                //       content: Column(
                                //         mainAxisSize:
                                //             MainAxisSize.min,
                                //         children: [
                                //           Container(
                                //             height: 80,
                                //             width: 80,
                                //             decoration:
                                //                 BoxDecoration(
                                //               borderRadius:
                                //                   BorderRadius
                                //                       .circular(50),
                                //               color: Colors
                                //                   .lightBlueAccent,
                                //               image:
                                //                   DecorationImage(
                                //                 image: AssetImage(
                                //                     "images/Staff.png"),
                                //                 fit: BoxFit.fill,
                                //               ),
                                //             ),
                                //           ),
                                //           SizedBox(
                                //             height: 5,
                                //           ),
                                //           Text(
                                //             'XYZ',
                                //             style: TextStyle(
                                //               fontWeight:
                                //                   FontWeight.w600,
                                //               fontSize: 20,
                                //               color:
                                //                   Colors.cyan[600],
                                //             ),
                                //           ),
                                //           SizedBox(
                                //             height: 10,
                                //           ),
                                //           Row(
                                //             children: [
                                //               Text(
                                //                 'Business Name',
                                //                 style: TextStyle(
                                //                   fontWeight:
                                //                       FontWeight
                                //                           .w600,
                                //                   color:
                                //                       Colors.white,
                                //                 ),
                                //               ),
                                //             ],
                                //           ),
                                //           Row(
                                //             children: [
                                //               Text(
                                //                 'ABC Hardware',
                                //                 style: TextStyle(
                                //                   fontStyle:
                                //                       FontStyle
                                //                           .italic,
                                //                   fontWeight:
                                //                       FontWeight
                                //                           .w500,
                                //                   color: Colors
                                //                       .cyan[600],
                                //                 ),
                                //               ),
                                //             ],
                                //           ),
                                //           Row(
                                //             children: [
                                //               Text(
                                //                 'Category',
                                //                 style: TextStyle(
                                //                   fontWeight:
                                //                       FontWeight
                                //                           .w600,
                                //                   color:
                                //                       Colors.white,
                                //                 ),
                                //               ),
                                //             ],
                                //           ),
                                //           Row(
                                //             children: [
                                //               Text(
                                //                 'Plumber',
                                //                 style: TextStyle(
                                //                   fontWeight:
                                //                       FontWeight
                                //                           .w500,
                                //                   color: Colors
                                //                       .cyan[600],
                                //                 ),
                                //               ),
                                //             ],
                                //           ),
                                //           Row(
                                //             children: [
                                //               Text(
                                //                 'Address',
                                //                 style: TextStyle(
                                //                   fontWeight:
                                //                       FontWeight
                                //                           .w600,
                                //                   color:
                                //                       Colors.white,
                                //                 ),
                                //               ),
                                //             ],
                                //           ),
                                //           Row(
                                //             children: [
                                //               Expanded(
                                //                 child: Text(
                                //                   'A-103, Someshwara Enclave, Vesu, Surat, 395007',
                                //                   style: TextStyle(
                                //                     fontWeight:
                                //                         FontWeight
                                //                             .w500,
                                //                     color: Colors
                                //                         .cyan[600],
                                //                   ),
                                //                 ),
                                //               ),
                                //             ],
                                //           ),
                                //           Row(
                                //             children: [
                                //               Text(
                                //                 'Contact',
                                //                 style: TextStyle(
                                //                   fontWeight:
                                //                       FontWeight
                                //                           .w600,
                                //                   color:
                                //                       Colors.white,
                                //                 ),
                                //               ),
                                //             ],
                                //           ),
                                //           Row(
                                //             children: [
                                //               Text(
                                //                 '989859596565',
                                //                 style: TextStyle(
                                //                   fontWeight:
                                //                       FontWeight
                                //                           .w500,
                                //                   color: Colors
                                //                       .cyan[600],
                                //                 ),
                                //               ),
                                //             ],
                                //           ),
                                //           Row(
                                //             children: [
                                //               Text(
                                //                 'Email',
                                //                 style: TextStyle(
                                //                   fontWeight:
                                //                       FontWeight
                                //                           .w600,
                                //                   color:
                                //                       Colors.white,
                                //                 ),
                                //               ),
                                //             ],
                                //           ),
                                //           Row(
                                //             children: [
                                //               Text(
                                //                 'abc@gmail.com',
                                //                 style: TextStyle(
                                //                   fontWeight:
                                //                       FontWeight
                                //                           .w500,
                                //                   color: Colors
                                //                       .cyan[600],
                                //                 ),
                                //               ),
                                //             ],
                                //           ),
                                //         ],
                                //       ),
                                //     );
                                //   },
                                // );
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
                                        Container(
                                          height: 55,
                                          width: 55,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius
                                                .circular(50),
                                            color: Colors
                                                .lightBlueAccent,
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  "images/user.png"),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            children: [
                                              GradientText(
                                                text:
                                                societyVendorDetails[
                                                index]
                                                ["Name"],
                                                colors: <Color>[
                                                  Color(0xffDA44bb),
                                                  Color(0xff8921aa)
                                                ],
                                                style: TextStyle(
                                                  fontSize: 20.0,
                                                  fontWeight:
                                                  FontWeight
                                                      .w600,
                                                ),
                                              ),
                                              GradientText(
                                                text: societyVendorDetails[
                                                index]
                                                ["ServiceName"],
                                                colors: <Color>[
                                                  Color(0xffDA44bb),
                                                  Color(0xff8921aa)
                                                ],
                                                style: TextStyle(
                                                  fontSize: 12.0,
                                                  // fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
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
                        ),
                      ),
                    ],
                  )
                      : Center(
                    child: Text('No Vendors Found'),
                  )
                      : Center(
                    child: CircularProgressIndicator(),
                  ),
                  Column(
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
                                child: Center(
                                    child: CircularProgressIndicator()),
                              )
                                  : ServiceData.length > 0
                                  ? GridView.builder(
                                  shrinkWrap: true,
                                  itemCount: ServiceData.length,
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
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}