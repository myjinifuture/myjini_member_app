import 'package:flutter/material.dart';
import 'package:easy_gradient_text/easy_gradient_text.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as cnst;
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Admin_App/Screens/AddSocietyVendor.dart';

class VendorsAdminScreen extends StatefulWidget {
  @override
  _VendorsAdminScreenState createState() => _VendorsAdminScreenState();
}

class _VendorsAdminScreenState extends State<VendorsAdminScreen> {
  List societyVendorDetails = [];
  List othersVendorDetails = [];
  bool societyVendorsLoading = false;
  bool othersVendorsLoading = false;

  @override
  void initState() {
    getSocietyVendors();
    getOthersVendors();
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
              societyVendorsLoading = false;
              societyVendorDetails = data.Data;
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

  getOthersVendors() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          othersVendorsLoading = true;
        });
        var data = {};
        Services.responseHandler(apiName: "member/getVendors", body: data).then(
            (data) async {
          print("data");
          print(data.Data);
          if (data.Data != null && data.Data.length > 0) {
            setState(() {
              othersVendorsLoading = false;
              othersVendorDetails = data.Data;
            });
          } else {
            setState(() {
              othersVendorsLoading = false;
            });
          }
        }, onError: (e) {
          showMsg("Something Went Wrong.\nPlease Try Again");
          setState(() {
            othersVendorsLoading = false;
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
                Navigator.of(context).pop();
                ;
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Vendors"),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                child: Text(
                  "Society",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              Tab(
                child: Text(
                  "Others",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
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
                                                societyVendorDetails[index][
                                                                "vendorImage"] !=
                                                            null
                                                    ? ClipOval(
                                                        child: FadeInImage
                                                            .assetNetwork(
                                                                placeholder:
                                                                    'images/user.png',
                                                                image:
                                                                    "${cnst.Image_Url}${societyVendorDetails[index]["vendorImage"]}",
                                                                width: 60,
                                                                height: 60,
                                                                fit: BoxFit
                                                                    .fill))
                                                    : ClipOval(
                                                        child: Image.asset(
                                                      'images/user.png',
                                                      width: 60,
                                                      height: 60,
                                                    ),),
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
                                                                index]["Name"],
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
                                                            societyVendorDetails[
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
                Positioned(
                  bottom: 0,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: FloatingActionButton(
                      tooltip: "Add Society Vendors",
                      foregroundColor: cnst.appPrimaryMaterialColor,
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddSocietyVendor(
                              vendorBelongsTo: "society",
                              onAddSocietyVendor: getSocietyVendors,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                othersVendorsLoading == false
                    ? othersVendorDetails.length > 0
                        ? Column(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  // shrinkWrap: true,
                                  itemCount: othersVendorDetails.length,
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
                                                othersVendorDetails[index][
                                                "vendorImage"] !=
                                                    null
                                                    ? ClipOval(
                                                    child: FadeInImage
                                                        .assetNetwork(
                                                        placeholder:
                                                        'images/user.png',
                                                        image:
                                                        "${cnst.Image_Url}${othersVendorDetails[index]["vendorImage"]}",
                                                        width: 60,
                                                        height: 60,
                                                        fit: BoxFit
                                                            .fill))
                                                    : ClipOval(
                                                  child: Image.asset(
                                                    'images/user.png',
                                                    width: 60,
                                                    height: 60,
                                                  ),),
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
                                                            othersVendorDetails[
                                                                index]["Name"],
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
                                                            othersVendorDetails[
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
                Positioned(
                  bottom: 0,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: FloatingActionButton(
                      tooltip: "Add Other Vendors",
                      foregroundColor: cnst.appPrimaryMaterialColor,
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddSocietyVendor(
                              vendorBelongsTo: "other",
                              onAddOthersVendor: getOthersVendors,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        // floatingActionButton: FloatingActionButton(
        //   foregroundColor: cnst.appPrimaryMaterialColor,
        //   child: Icon(
        //     Icons.add,
        //     color: Colors.white,
        //   ),
        //   onPressed: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) => AddSocietyVendor(
        //           onAddSocietyVendor: getSocietyVendors,
        //         ),
        //       ),
        //     );
        //   },
        // ),
      ),
    );
  }
}
