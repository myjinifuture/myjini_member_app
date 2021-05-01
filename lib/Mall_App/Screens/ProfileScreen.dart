import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Mall_App/Common/Colors.dart';
import 'package:smart_society_new/Mall_App/Common/Constant.dart';
import 'package:smart_society_new/Mall_App/Common/services.dart';
import 'package:smart_society_new/Mall_App/Providers/CartProvider.dart';
import 'package:smart_society_new/Mall_App/Screens/AddressScreen.dart';
import 'package:smart_society_new/Mall_App/Screens/LoginScreen.dart';
import 'package:smart_society_new/Mall_App/Screens/MyOrder.dart';
import 'package:smart_society_new/Mall_App/Screens/MyPointScreen.dart';
import 'package:smart_society_new/Mall_App/Screens/PromocodePage.dart';
import 'package:smart_society_new/Mall_App/Screens/Tearmscondition.dart';
import 'package:smart_society_new/Mall_App/transitions/slide_route.dart';
import 'package:url_launcher/url_launcher.dart';

class contactUs extends StatefulWidget {
  var contactdata, whtspdata, whtscall, phonedata, emaildata;

  contactUs(
      {this.contactdata,
      this.whtspdata,
      this.whtscall,
      this.phonedata,
      this.emaildata});

  @override
  _contactUsState createState() => _contactUsState();
}

class _contactUsState extends State<contactUs> {
  bool isLoading = false;

  void launchwhatsapp({
    @required String phone,
    @required String message,
  }) async {
    String url() {
      if (Platform.isIOS) {
        return "whatsapp://wa.me/$phone/?text=${Uri.parse(message)}";
      } else {
        return "whatsapp://send?phone=$phone&text=${Uri.parse(message)}";
      }
    }

    if (await canLaunch(url())) {
      await launch(url());
    } else {
      throw 'Could not launch ${url()}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 9.0, top: 3),
                  child: Icon(
                    Icons.clear,
                    size: 20,
                    color: Colors.grey,
                  ),
                ),
              )),
          Container(
              // color: Colors.redAccent,
              alignment: Alignment.center,
              height: 130,
              width: 150,
              child: Column(
                children: [
                  Image.asset(
                    'images/gini.png',
                    height: 100,
                  ),
                  Text(
                    "   MYJINI",
                    style: TextStyle(
                        color: appPrimaryMaterialColor,
                        fontWeight: FontWeight.w600),
                  )
                  // Align(
                  //   alignment: Alignment.center,
                  //   child: Image.asset(
                  //     'images/myginitext.png',
                  //     height: 100,
                  //     color: appPrimaryMaterialColor,
                  //   ),
                  // )
                ],
              )),
          Padding(
            padding: const EdgeInsets.only(left: 50.0, top: 8),
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 3.0),
                      child: Icon(
                        Icons.mail,
                        color: Colors.grey,
                        size: 19,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Text(
                        "${widget.emaildata}",
                        style: TextStyle(
                            color: appPrimaryMaterialColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 7.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 3.0),
                        child: Icon(
                          Icons.call,
                          color: Colors.grey,
                          size: 19,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 7.0),
                        child: Text(
                          "${widget.phonedata}",
                          style: TextStyle(
                              color: appPrimaryMaterialColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 7.0),
                  child: Row(
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(top: 3.0),
                          child: Image.asset(
                            "assets/assets/whatsapp.png",
                            width: 21,
                            color: Colors.grey,
                          )),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text(
                          "${widget.whtscall}",
                          style: TextStyle(
                              color: appPrimaryMaterialColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 21.0, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    launch(('mailto:// ${widget.emaildata}'));
                  },
                  child: CircleAvatar(
                    child: Icon(
                      Icons.mail,
                      color: Colors.white,
                      size: 19,
                    ),
                    backgroundColor: appPrimaryMaterialColor,
                    radius: 19,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: GestureDetector(
                    onTap: () {
                      launch(('tel:// ${widget.phonedata}'));
                    },
                    child: CircleAvatar(
                      child: Icon(
                        Icons.call,
                        color: Colors.white,
                        size: 19,
                      ),
                      backgroundColor: appPrimaryMaterialColor,
                      radius: 19,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    launchwhatsapp(
                        phone: "${widget.whtspdata}",
                        message: "${widget.whtscall}");
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: CircleAvatar(
                      child: Image.asset(
                        "assets/assets/whatsapp.png",
                        width: 21,
                        color: Colors.white,
                      ),
                      backgroundColor: appPrimaryMaterialColor,
                      radius: 19,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 13.0, bottom: 25, left: 9, right: 9),
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: appPrimaryMaterialColor, width: 1)),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text(
                    "${widget.contactdata}",
                    style: TextStyle(
                        color: appPrimaryMaterialColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 4,
            color: appPrimaryMaterialColor,
            width: MediaQuery.of(context).size.width,
          ),
        ],
      ),
      contentPadding: const EdgeInsets.only(
        top: 6.0,
        bottom: 0.0,
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  bool isgetaddressLoading = false;
  List getaddressList = [];
  bool isLoading = false;
  bool isPointsLoading = false;
  List generaldatalist = [];
  String Points = "0";
  List pointList = [];

  void initState() {
    getlocaldata();
    _getAddress();
    _SettingApi();
    _points();
  }

  _points() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isPointsLoading = true;
        });
        FormData body = FormData.fromMap({"CustomerId": CustomerId});
        print(body.fields);
        Services.postforlist(apiname: 'getPointsTest', body: body).then(
            (responselist) async {
          setState(() {
            isPointsLoading = false;
          });
          if (responselist.length > 0) {
            setState(() {
              pointList = responselist[1]["Points"];
              Points = responselist[0]["PointsDetail"][0]["Total"].toString();
            });
          } else {
            Fluttertoast.showToast(msg: "Data Not Found!");
          }
        }, onError: (e) {
          setState(() {
            isPointsLoading = false;
          });
          print("error on call -> ${e.message}");
          Fluttertoast.showToast(msg: "something went wrong");
        });
      }
    } on SocketException catch (_) {
      Fluttertoast.showToast(msg: "No Internet Connection");
    }
  }

  String whatsapp, msg, address;
  String phone, email;
  String CustomerId,
      CustomerName,
      Customerphone,
      CustomerEmail,
      AddressId,
      AddressHouseNo,
      AddressName,
      AddressAppartmentName,
      AddressStreet,
      AddressLandmark,
      AddressArea,
      AddressType,
      AddressPincode,
      City;
  SharedPreferences preferences;

  getlocaldata() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      CustomerId = preferences.getString(Session.customerId);
      CustomerName = preferences.getString(Session.CustomerName);
      Customerphone = preferences.getString(Session.CustomerPhoneNo);
      CustomerEmail = preferences.getString(Session.CustomerEmailId);
      AddressId = preferences.getString(AddressSession.AddressId);
      AddressHouseNo = preferences.getString(AddressSession.AddressHouseNo);
      AddressPincode = preferences.getString(AddressSession.AddressPincode);
      AddressAppartmentName =
          preferences.getString(AddressSession.AddressAppartmentName);
      AddressStreet = preferences.getString(AddressSession.AddressStreet);
      AddressLandmark = preferences.getString(AddressSession.AddressLandmark);
      AddressArea = preferences.getString(AddressSession.AddressArea);
      AddressType = preferences.getString(AddressSession.AddressType);
      City = preferences.getString(AddressSession.City);
    });
    print(AddressPincode);
  }

  _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(
            "Logout",
            style: TextStyle(color: appPrimaryMaterialColor),
          ),
          content: new Text("Are you sure want to logout..."),
          actions: <Widget>[
            new FlatButton(
              child: new Text(
                "Cancel",
                style: TextStyle(color: appPrimaryMaterialColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(color: appPrimaryMaterialColor),
              ),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.clear();

                Navigator.pushReplacement(
                    context, SlideLeftRoute(page: LoginScreen()));
              },
            ),
          ],
        );
      },
    );
  }

  _contactUs() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return contactUs(
            contactdata: address,
            whtspdata: msg,
            emaildata: email,
            whtscall: whatsapp,
            phonedata: phone);
      },
    );
  }
  //AlertDialog(
  //           content: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Align(
  //                   alignment: Alignment.topRight,
  //                   child: GestureDetector(
  //                     onTap: () {
  //                       Navigator.of(context).pop();
  //                     },
  //                     child: Padding(
  //                       padding: const EdgeInsets.only(right: 9.0, top: 3),
  //                       child: Icon(
  //                         Icons.clear,
  //                         size: 20,
  //                         color: Colors.grey,
  //                       ),
  //                     ),
  //                   )),
  //               Container(
  //                 // color: Colors.redAccent,
  //                 height: 100,
  //                 width: 120,
  //                 child: Image.asset("assets/assets/basket.png"),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.only(left: 50.0, top: 8),
  //                 child: Column(
  //                   children: [
  //                     Row(
  //                       children: [
  //                         Padding(
  //                           padding: const EdgeInsets.only(top: 3.0),
  //                           child: Icon(
  //                             Icons.mail,
  //                             color: Colors.grey,
  //                             size: 19,
  //                           ),
  //                         ),
  //                         Padding(
  //                           padding: const EdgeInsets.only(left: 5.0),
  //                           child: Text(
  //                             "meghatech@gmail.com",
  //                             style: TextStyle(
  //                                 color: appPrimaryMaterialColor,
  //                                 fontSize: 14,
  //                                 fontWeight: FontWeight.w500),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                     Padding(
  //                       padding: const EdgeInsets.only(top: 7.0),
  //                       child: Row(
  //                         children: [
  //                           Padding(
  //                             padding: const EdgeInsets.only(top: 3.0),
  //                             child: Icon(
  //                               Icons.call,
  //                               color: Colors.grey,
  //                               size: 19,
  //                             ),
  //                           ),
  //                           Padding(
  //                             padding: const EdgeInsets.only(left: 7.0),
  //                             child: Text(
  //                               "+9664742543",
  //                               style: TextStyle(
  //                                   color: appPrimaryMaterialColor,
  //                                   fontSize: 12,
  //                                   fontWeight: FontWeight.w500),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                     Padding(
  //                       padding: const EdgeInsets.only(top: 7.0),
  //                       child: Row(
  //                         children: [
  //                           Padding(
  //                               padding: const EdgeInsets.only(top: 3.0),
  //                               child: Image.asset(
  //                                 "assets/assets/whatsapp.png",
  //                                 width: 21,
  //                                 color: Colors.grey,
  //                               )),
  //                           Padding(
  //                             padding: const EdgeInsets.only(left: 5.0),
  //                             child: Text(
  //                               "+9664742543",
  //                               style: TextStyle(
  //                                   color: appPrimaryMaterialColor,
  //                                   fontSize: 12,
  //                                   fontWeight: FontWeight.w500),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.only(top: 21.0, bottom: 35),
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     CircleAvatar(
  //                       child: Icon(
  //                         Icons.mail,
  //                         color: Colors.white,
  //                         size: 19,
  //                       ),
  //                       backgroundColor: appPrimaryMaterialColor,
  //                       radius: 19,
  //                     ),
  //                     Padding(
  //                       padding: const EdgeInsets.only(left: 12.0),
  //                       child: CircleAvatar(
  //                         child: Icon(
  //                           Icons.call,
  //                           color: Colors.white,
  //                           size: 19,
  //                         ),
  //                         backgroundColor: appPrimaryMaterialColor,
  //                         radius: 19,
  //                       ),
  //                     ),
  //                     Padding(
  //                       padding: const EdgeInsets.only(left: 12.0),
  //                       child: CircleAvatar(
  //                         child: Image.asset(
  //                           "assets/assets/whatsapp.png",
  //                           width: 21,
  //                           color: Colors.white,
  //                         ),
  //                         backgroundColor: appPrimaryMaterialColor,
  //                         radius: 19,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               Container(
  //                 height: 4,
  //                 color: appPrimaryMaterialColor,
  //                 width: MediaQuery.of(context).size.width,
  //               ),
  //             ],
  //           ),
  //           contentPadding: const EdgeInsets.only(
  //             top: 6.0,
  //             bottom: 0.0,
  //           ),
  //         );

  @override
  Widget build(BuildContext context) {
    CartProvider provider = Provider.of<CartProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text("My Profile",
            style: TextStyle(color: Colors.white, fontSize: 18)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 190,
              //color: Colors.red[300],
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 17.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/assets/profile.png'),
                            backgroundColor: appPrimaryMaterialColor,
                            radius: 35,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("${CustomerName}",
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: appPrimaryMaterialColor)),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text("${CustomerEmail}",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: appPrimaryMaterialColor)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text("${Customerphone}",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: appPrimaryMaterialColor)),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 22.0, right: 12, left: 12),
                    child: isgetaddressLoading == true
                        ? Container(
                            height: 75,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                    color: Colors.grey[100], width: 0.5)),
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 3.5,
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    appPrimaryMaterialColor),
                              ),
                            ),
                          )
                        : getaddressList.length > 0
                            ? Container(
                                height: 79,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.grey[100],
                                ),
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 6.0),
                                          child: Icon(
                                            Icons.location_on,
                                            color: appPrimaryMaterialColor,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15.0, bottom: 10, top: 2),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5.0),
                                                child: Text(
                                                    "${AddressHouseNo}" +
                                                        "," +
                                                        "${AddressAppartmentName}" +
                                                        "," +
                                                        "${AddressStreet}",
                                                    style: TextStyle(
                                                      color: Colors.grey[700],
                                                      fontSize: 14,
                                                    )),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 2.0),
                                                child: Text(
                                                    "${AddressLandmark}" +
                                                        "," +
                                                        "${AddressArea}",
                                                    style: TextStyle(
                                                      color: Colors.grey[700],
                                                      fontSize: 14,
                                                    )),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 2.0),
                                                child: Text(
                                                    "${City}" +
                                                        "-" +
                                                        "${AddressPincode}",
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        color:
                                                            Colors.grey[700])),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushReplacement(
                                            context,
                                            SlideLeftRoute(
                                                page: AddressScreen()));
                                      },
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 18.0),
                                        child: Image.asset(
                                            'assets/assets/editicon.png',
                                            width: 18,
                                            height: 18,
                                            color: appPrimaryMaterialColor),
                                      ),
                                    ),
                                    // Padding(
                                    //   padding: const EdgeInsets.only(right: 7.0, top: 20),
                                    //   child: Container(
                                    //     height: 30,
                                    //     width: MediaQuery.of(context).size.width / 4.5,
                                    //     decoration: BoxDecoration(
                                    //         border: Border.all(color: Colors.red[400]),
                                    //         borderRadius: BorderRadius.circular(5)),
                                    //     child: Center(
                                    //         child: Text(
                                    //       "Change",
                                    //       style: TextStyle(color: Colors.red[400]),
                                    //     )),
                                    //   ),
                                    // )
                                  ],
                                ),
                              )
                            : Center(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pushReplacement(context,
                                        SlideLeftRoute(page: AddressScreen()));
                                  },
                                  child: Container(
                                    height: 70,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                            color: appPrimaryMaterialColor,
                                            width: 0.5)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add,
                                          size: 18,
                                          color: appPrimaryMaterialColor,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 3.0),
                                          child: Text(
                                            "Add Address",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: appPrimaryMaterialColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Container(
                color: Colors.grey[200],
                height: 10,
                width: MediaQuery.of(context).size.width,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, SlideLeftRoute(page: MyOrder()));
                },
                child: Container(
                  color: Colors.white,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Image.asset('assets/assets/shoppingcart.png',
                            width: 25, color: appPrimaryMaterialColor),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Text("My Orders",
                            style: TextStyle(
                                color: appPrimaryMaterialColor, fontSize: 16)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: 0.8,
              color: Colors.grey[300],
            ),
            provider.settingList[0]["SettingShowReedemPoints"] == true
                ? Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  SlideLeftRoute(
                                      page: MyPointScreen(
                                          pointsData: pointList)));
                            },
                            child: Container(
                              color: Colors.white,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Image.asset(
                                        'assets/assets/earning.png',
                                        width: 25,
                                        color: appPrimaryMaterialColor),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 12.0),
                                    child: Text("My Points",
                                        style: TextStyle(
                                            color: appPrimaryMaterialColor,
                                            fontSize: 16)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Text('${Points}',
                            style: TextStyle(
                                color: appPrimaryMaterialColor, fontSize: 16))
                      ],
                    ),
                  )
                : Container(),
            Container(
              height: 0.8,
              color: Colors.grey[300],
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, SlideLeftRoute(page: promoCode()));
                },
                child: Container(
                  color: Colors.white,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Image.asset('assets/assets/coupon.png',
                            width: 26, color: appPrimaryMaterialColor),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Text("My Promocode",
                            style: TextStyle(
                                color: appPrimaryMaterialColor, fontSize: 16)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: 0.8,
              color: Colors.grey[300],
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      SlideLeftRoute(
                          page: TearmsCon(
                        tearmscondition: generaldatalist[0]
                            ["SettingAboutUsURL"],
                        title: "About Us",
                      )));
                },
                child: Container(
                  color: Colors.white,
                  child: Row(
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Icon(
                            Icons.info_outline,
                            color: appPrimaryMaterialColor,
                          )),
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Text("About Us",
                            style: TextStyle(
                                color: appPrimaryMaterialColor, fontSize: 16)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: 0.8,
              color: Colors.grey[300],
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      SlideLeftRoute(
                          page: TearmsCon(
                        tearmscondition: generaldatalist[0]["SettingFAQ"],
                        title: "FAQ",
                      )));
                },
                child: Container(
                  color: Colors.white,
                  child: Row(
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Icon(
                            Icons.help_outline,
                            color: appPrimaryMaterialColor,
                          )),
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Text("FAQ",
                            style: TextStyle(
                                color: appPrimaryMaterialColor, fontSize: 16)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: 0.8,
              color: Colors.grey[300],
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      SlideLeftRoute(
                          page: TearmsCon(
                        tearmscondition: generaldatalist[0]
                            ["SettingTermsConditionURL"],
                        title: "Tearms & Condition",
                      )));
                },
                child: Container(
                  color: Colors.white,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Image.asset('assets/assets/tearmscon.png',
                            width: 25, color: appPrimaryMaterialColor),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Text("Tearms & Condition",
                            style: TextStyle(
                                color: appPrimaryMaterialColor, fontSize: 16)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: 0.8,
              color: Colors.grey[300],
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: GestureDetector(
                onTap: () {
                  _contactUs();
                },
                child: Container(
                  color: Colors.white,
                  child: Row(
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Icon(
                            Icons.call,
                            size: 22,
                            color: appPrimaryMaterialColor,
                          )),
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Text("Contact Us",
                            style: TextStyle(
                                color: appPrimaryMaterialColor, fontSize: 16)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: 0.8,
              color: Colors.grey[300],
            ),
            // Padding(
            //   padding: const EdgeInsets.all(14.0),
            //   child: GestureDetector(
            //     onTap: () {
            //       _showDialog(context);
            //     },
            //     child: Container(
            //       child: Row(
            //         children: [
            //           Padding(
            //             padding: const EdgeInsets.only(left: 8.0),
            //             child: Image.asset('assets/assets/logout.png',
            //                 width: 23, color: appPrimaryMaterialColor),
            //           ),
            //           Padding(
            //             padding: const EdgeInsets.only(left: 12.0),
            //             child: Text("Logout",
            //                 style: TextStyle(
            //                   color: appPrimaryMaterialColor,
            //                   fontSize: 16,
            //                 )),
            //           )
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            // Container(
            //   height: 0.8,
            //   color: Colors.grey[300],
            // ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 30,
        child: Center(child: Text("Version 1.0.0")),
      ),
    );
  }

  _getAddress() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isgetaddressLoading = true;
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();

        FormData body = FormData.fromMap({
          "CustomerId": prefs.getString(Session.customerId),
        });
        Services.postforlist(apiname: 'getAddress', body: body).then(
            (ResponseList) async {
          if (ResponseList.length > 0) {
            setState(() {
              getaddressList = ResponseList;
              isgetaddressLoading = false;

              AddressStreet = ResponseList[0]["AddressStreet"];
              AddressArea = ResponseList[0]["AddressArea"];
              AddressLandmark = ResponseList[0]["AddressLandmark"];
              AddressAppartmentName = ResponseList[0]["AddressAppartmentName"];
              AddressPincode = ResponseList[0]["AddressPincode"];
              AddressHouseNo = ResponseList[0]["AddressHouseNo"];
              City = ResponseList[0]["AddressCityName"];
            });
          } else {
            setState(() {
              isgetaddressLoading = false;
            });
          }
        }, onError: (e) {
          setState(() {
            isgetaddressLoading = false;
          });
          print("error on call -> ${e.message}");
          Fluttertoast.showToast(msg: "Something Went Wrong");
        });
      }
    } on SocketException catch (_) {
      Fluttertoast.showToast(msg: "No Internet Connection.");
    }
  }

  _SettingApi() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        Services.postforlist(apiname: 'getSetting').then((responselist) async {
          setState(() {
            isLoading = false;
          });
          if (responselist.length > 0) {
            setState(() {
              generaldatalist = responselist;
              whatsapp = "+91" + responselist[0]["SettingPhoneNumber"];
              msg = responselist[0]["SettingWhatsAppMessage"];
              address = responselist[0]["SettingAddress"];
              phone = "+91" + responselist[0]["SettingPhoneNumber"];
              email = responselist[0]["SettingEmailId"];
              //set "data" here to your variable
            });
            print(phone);
            print(email);
          } else {
            Fluttertoast.showToast(msg: "No Data Found !");
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          print("error on call -> ${e.message}");
          Fluttertoast.showToast(msg: "something went wrong");
        });
      }
    } on SocketException catch (_) {
      Fluttertoast.showToast(msg: "No Internet Connection");
//      showMsg("No Internet Connection.");
    }
  }
}
