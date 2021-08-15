import 'dart:io';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/animation.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart';
import '../common/Services1.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_society_new/Member_App/Services/SubServicesScreen.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as cnst;
import 'package:smart_society_new/Member_App/component/MyServiceRequestComponent.dart';
import 'package:easy_gradient_text/easy_gradient_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:smart_society_new/Member_App/screens/RateVendorScreen.dart';
import 'package:smart_society_new/Member_App/screens/StaffReviewListingScreen.dart';
import 'package:intl/intl.dart';

class ServicesScreen extends StatefulWidget {
  var search;
  int initialIndex;

  ServicesScreen({this.search, this.initialIndex});

  @override
  _ServicesScreenState createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen>
    with TickerProviderStateMixin {
  TextEditingController _txtadd = TextEditingController();
  bool isLoading = false;
  bool isServiceDataLoading = false;
  List ServiceData = [];
  TabController _tabController;
  List NewList = [];
  List vendorgetAllList = [];
  List getAllVendors = [];
  ProgressDialog pr;
  List societyVendorDetails = [];
  bool societyVendorsLoading = false;
  int _index = 0;

  @override
  void initState() {
    setState(() {
      getSocietyVendors();
      _ServiceData();
      getAllVendor();
      _tabController = new TabController(
          vsync: this, length: 3, initialIndex: widget.initialIndex);
    });
  }

  _openWhatsapp(mobile) {
    String whatsAppLink = cnst.whatsAppLink;
    String urlwithmobile = whatsAppLink.replaceAll("#mobile", "91$mobile");
    String urlwithmsg = urlwithmobile.replaceAll("#msg", "");
    launch(urlwithmsg);
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

  getAllVendor() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var memberId = prefs.getString(Session.Member_Id);
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var body = {"memberId": memberId};
        print(body);
        setState(() {
          isLoading = true;
        });
        Services.responseHandler(apiName: "member/getVendorDate", body: body)
            .then((data) async {
          if (data.Data != null) {
            setState(() {
              vendorgetAllList = data.Data;
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

  VendorRequest(id, date, description) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var categoryId = prefs.getString(Session.VendorCateId);
      var memId = prefs.getString(Session.Member_Id);
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var body = {
          "memberId": memId,
          "date": DateFormat('dd/MM/yyyy').format(selectedDate),
          "description": description,
          "vendorCategoryId": categoryId,
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
            });
          } else if (data.Data.toString() == "0") {
            setState(() {
              Fluttertoast.showToast(
                  msg: "Member Rejected!!!",
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

  _ServiceData() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      SharedPreferences pref = await SharedPreferences.getInstance();
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isServiceDataLoading = true;
        });

        Services.responseHandler(
            apiName: "admin/getAllVendorCategory", body: {}).then((data) async {
          setState(() {
            isServiceDataLoading = false;
          });
          if (data.Data != null && data.Data.length > 0) {
            setState(() {
              ServiceData = data.Data;
              print("categoryId..............");
              print(data.Data);
            });
          } else {
            setState(() {
              isServiceDataLoading = false;
            });
          }
        }, onError: (e) {
          setState(() {
            isServiceDataLoading = false;
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
                ;
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
            onTap: () async {
              /*Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ServiceList(
                    ServiceData[index],
                  ),
                ),
              );*/
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString(Session.VendorCateId, ServiceData[index]["_id"]);
              print(prefs.getString(Session.VendorCateId));
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
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Card(
                elevation: 7,
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
                              image:
                                  Image_Url + '${ServiceData[index]["image"]}',
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
            setState(() async {
              if (widget.search != null) {
                societyVendorsLoading = false;
                for (int i = 0; i < data.Data.length; i++) {
                  data.Data[i]["ServiceNameFull"] =
                      data.Data[i]["ServiceName"] + "ian";
                  if (data.Data[i]["ServiceName"]
                      .toString()
                      .toUpperCase()
                      .contains(widget.search.toUpperCase())) {
                    societyVendorDetails.add(data.Data[i]);
                  }
                }
              } else {
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

  DateTime selectedDate = DateTime.now();

  _selectDate(context) async {
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

  final _imageUrls = [
    "http://cashkaro.com/blog/wp-content/uploads/sites/5/2018/03/Housejoy-AC-Service-Offer.gif",
    "https://www.cleaningbyrosie.com/wp-content/uploads/2016/12/facebook-cover2-630x315.jpg",
    "https://i.ytimg.com/vi/FTguamlXGWs/maxresdefault.jpg"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                Tab(
                  child: Text(
                    "Vendor Request",
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
                              children:[
                                Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Expanded(
                                    child: ListView.builder(
                                      physics: BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: societyVendorDetails.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                  content: Stack(
                                                    children: [
                                                      Container(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.13,
                                                        decoration:
                                                            new BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topRight:
                                                                Radius.circular(
                                                                    10),
                                                            topLeft:
                                                                Radius.circular(
                                                                    10),
                                                          ),
                                                          gradient: new LinearGradient(
                                                              colors: [
                                                                Color(
                                                                    0xffDA44bb),
                                                                Color(
                                                                    0xff8921aa)
                                                              ],
                                                              begin:
                                                                  const FractionalOffset(
                                                                      0.0, 0.0),
                                                              end:
                                                                  const FractionalOffset(
                                                                      1.0, 0.0),
                                                              stops: [0.0, 1.0],
                                                              tileMode: TileMode
                                                                  .clamp),
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
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 15,
                                                          ),
                                                          ClipOval(
                                                            child: societyVendorDetails[
                                                                            index]
                                                                        [
                                                                        "vendorImage"] !=
                                                                    ""
                                                                ? FadeInImage.assetNetwork(
                                                                    placeholder:
                                                                        '',
                                                                    image: Image_Url +
                                                                        "${societyVendorDetails[index]["vendorImage"]}",
                                                                    width: 80,
                                                                    height: 80,
                                                                    fit: BoxFit
                                                                        .fill)
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
                                                            societyVendorDetails[
                                                                index]["Name"],
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 20,
                                                              color: Colors
                                                                  .grey[700],
                                                            ),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                societyVendorDetails[
                                                                        index][
                                                                    "ContactNo"],
                                                                style:
                                                                    TextStyle(
                                                                  // fontStyle: FontStyle
                                                                  //     .italic,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Colors
                                                                          .grey[
                                                                      600],
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
                                                                societyVendorDetails[
                                                                        index][
                                                                    "CompanyName"],
                                                                style:
                                                                    TextStyle(
                                                                  // fontStyle: FontStyle
                                                                  //     .italic,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Colors
                                                                          .grey[
                                                                      600],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
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
                                                                  societyVendorDetails[
                                                                          index]
                                                                      [
                                                                      "Address"],
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style:
                                                                      TextStyle(
                                                                    // fontStyle: FontStyle
                                                                    //     .italic,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .grey,
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
                                                                societyVendorDetails[
                                                                        index]
                                                                    ["emailId"],
                                                                style:
                                                                    TextStyle(
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .grey,
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
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          IconButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            icon: Icon(
                                                              Icons
                                                                  .close_rounded,
                                                            ),
                                                            color: Colors.white,
                                                          ),
                                                        ],
                                                      ),
                                                      societyVendorDetails[
                                                                      index][
                                                                  "AverageRating"] ==
                                                              null
                                                          ? Row()
                                                          : Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                top: 65,
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            15.0),
                                                                    child:
                                                                        Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(5),
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                      height:
                                                                          25,
                                                                      width: 60,
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Text(
                                                                            societyVendorDetails[index]["AverageRating"].toString(),
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 12,
                                                                              fontWeight: FontWeight.w600,
                                                                              color: cnst.appPrimaryMaterialColor,
                                                                            ),
                                                                          ),
                                                                          Icon(
                                                                            Icons.star_rate_rounded,
                                                                            color:
                                                                                Colors.amberAccent,
                                                                            size:
                                                                                20,
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      Navigator
                                                                          .push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              StaffReviewListingScreen(
                                                                            ratingsData:
                                                                                societyVendorDetails[index]["VendorRatings"],
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          right:
                                                                              15.0),
                                                                      child:
                                                                          Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(5),
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                        height:
                                                                            25,
                                                                        width:
                                                                            60,
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            'View All',
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 12,
                                                                              color: cnst.appPrimaryMaterialColor,
                                                                              fontWeight: FontWeight.w600,
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
                                                      child: societyVendorDetails[
                                                                      index][
                                                                  "vendorImage"] !=
                                                              ""
                                                          ? FadeInImage.assetNetwork(
                                                              placeholder: '',
                                                              image: Image_Url +
                                                                  "${societyVendorDetails[index]["vendorImage"]}",
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
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          GestureDetector(
                                                            onTap: () async {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          RateVendorScreen(
                                                                    type: 0,
                                                                    vendorId: societyVendorDetails[
                                                                            index]
                                                                        ["_id"],
                                                                    onAddVendorReview:
                                                                        getSocietyVendors,
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
                                                                color: Colors
                                                                    .red[100],
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    GradientText(
                                                                      text:
                                                                          'RATE NOW',
                                                                      colors: <
                                                                          Color>[
                                                                        Color(
                                                                            0xffDA44bb),
                                                                        Color(
                                                                            0xff8921aa)
                                                                      ],
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w600,
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
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 10.0),
                                                    ),
                                                     IconButton(
                                                      icon: Image.asset(
                                                        "images/whatsapp.png",
                                                        width: 50,
                                                        height: 50,
                                                      ),
                                                      onPressed: ()async {
                                                        _openWhatsapp(
                                                            societyVendorDetails[
                                                                    index]
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
                                                            "tel:${societyVendorDetails[index]["ContactNo"]}");
                                                      },
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 10.0),
                                                    )
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
                      // Container(
                      //     child: CarouselSlider(
                      //       height: 115,
                      //       // aspectRatio: 16/5,
                      //       viewportFraction: 0.8,
                      //       initialPage: 0,
                      //       // enlargeCenterPage: true,
                      //       reverse: false,
                      //       autoPlayCurve: Curves.fastOutSlowIn,
                      //       autoPlay: true,
                      //       items: _imageUrls.map((i) {
                      //         return Builder(builder: (BuildContext context) {
                      //           return Padding(
                      //             padding: const EdgeInsets.only(
                      //                 top: 10.0, left: 4.0, right: 4.0),
                      //             child: Container(
                      //               width: MediaQuery.of(context).size.width,
                      //               child: FadeInImage.assetNetwork(
                      //                 placeholder: "images/placeholder.png",
                      //                 image: '$i',
                      //                 fit: BoxFit.fill,
                      //               ),
                      //             ),
                      //           );
                      //         });
                      //       }).toList(),
                      //     )),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Container(
                              child: isServiceDataLoading == true
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
                  SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              vendorgetAllList.length > 0
                                  ? ListView.builder(
                                      physics: BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: vendorgetAllList.length,
                                      itemBuilder: (context, index) {
                                        return Card(
                                          elevation: 8,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15.0,
                                                top: 10,
                                                bottom: 10.0,
                                                right: 10.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                ContainerNL("Date              :",vendorgetAllList[index]
                                                ["date"]),
                                                ContainerNL("Time              :",vendorgetAllList[index]["memberTime"]),
                                                ContainerNL("Name            :",vendorgetAllList[index]
                                                ["Name"]),
                                                ContainerNL("Category      :",vendorgetAllList[index]["vendorCategoryName"]),
                                                Divider(
                                                  color: Colors.grey,
                                                ),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 5.0)),
                                                 Row(
                                                   children: [
                                                      Text("Description :",style: TextStyle(fontFamily: "OpenSans", fontWeight: FontWeight.bold),),
                                                     ContainerNL("", vendorgetAllList[
                                                     index]
                                                     ["description"],),
                                                   ],
                                                 ),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 10.0)),
                                                Row(
                                                  children: [
                                                    Padding(padding: EdgeInsets.only(left: 110.0)),
                                                    Container(
                                                      height: MediaQuery.of(context).size.height/28,
                                                      child: RaisedButton(
                                                        onPressed: (){
                                                        },elevation: 8,
                                                        shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(8)
                                                      ),color: Colors.white,
                                                        child: Text(
                                                           "Pendding",
                                                          style: TextStyle(
                                                              color:Colors.red[700],
                                                              fontSize: 14.0,
                                                              fontWeight:
                                                              FontWeight.w600,
                                                              fontFamily: "OpenSans"),
                                                        ),),
                                                      ),
                                                  ],
                                                ),

                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  : Container(
                                      child: Center(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(top: 70),
                                            ),
                                            Lottie.asset(
                                                "assets/json/emptydata.json"),
                                            Text(
                                              "No Data Found..",
                                              style: TextStyle(
                                                  fontFamily: "OpenSans",
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ContainerNL(text, value) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Row(children: [
        Text(
          text,
          style: TextStyle(fontFamily: "OpenSans", fontWeight: FontWeight.bold),
        ),
        Padding(padding: EdgeInsets.only(left: 8.0)),
        Container(
          width: MediaQuery.of(context).size.width / 1.9,
          child: Text(
            value,
            style: TextStyle(fontFamily: "OpenSans"),
          ),
        ),
      ]),
    );
  }


}
