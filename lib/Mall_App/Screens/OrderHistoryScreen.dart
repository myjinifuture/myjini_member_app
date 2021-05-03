import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Mall_App/Common/Constant.dart';
import 'package:smart_society_new/Mall_App/Common/services.dart';
import 'package:smart_society_new/Mall_App/CustomWidgets/LoadingComponent.dart';
import 'package:smart_society_new/Mall_App/CustomWidgets/NoFoundComponent.dart';

class OrderHistoryScreen extends StatefulWidget {
  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  List OrderHistoryList = [];
  String CustomerId;
  bool isorderDetailLoading = false;

  @override
  void initState() {
    _getorderHistory();
    getlocaldata();
  }

  getlocaldata() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    CustomerId = await preferences.getString(Session.customerId);
  }

  _getorderHistory() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isorderDetailLoading = true;
        });
        FormData body = FormData.fromMap({"CustomerId": CustomerId});
        print(body.fields);
        Services.postforlist(apiname: 'orderHistoryTest', body: body).then(
            (responselist) async {
          setState(() {
            isorderDetailLoading = false;
          });
          if (responselist.length > 0) {
            setState(() {
              OrderHistoryList = responselist;
            });
          } else {
            Fluttertoast.showToast(msg: "Data Not Found!");
          }
        }, onError: (e) {
          setState(() {
            isorderDetailLoading = false;
          });
          print("error on call -> ${e.message}");
          Fluttertoast.showToast(msg: "something went wrong");
        });
      }
    } on SocketException catch (_) {
      Fluttertoast.showToast(msg: "No Internet Connection");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        // appBar: AppBar(
        //   elevation: 1,
        //   title: Text("Order History",
        //       style: TextStyle(color: Colors.white, fontSize: 18)),
        // ),
        body: isorderDetailLoading
            ? LoadingComponent()
            : OrderHistoryList.length > 0
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 13.0, top: 30),
                        child: Text("Address",
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 15,
                            )),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 10.0, right: 8, left: 8),
                        child: Container(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 13.0, bottom: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                            "${OrderHistoryList[0]["CustomerName"]}",
                                            style: TextStyle(
                                              color: Colors.grey[700],
                                              fontSize: 14,
                                            )),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 9.0),
                                        child: Text(
                                            "${OrderHistoryList[0]["AddressHouseNo"]}" +
                                                " , " +
                                                "${OrderHistoryList[0]["AddressAppartmentName"]}",
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey[700])),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 2.0),
                                        child: Text(
                                            "${OrderHistoryList[0]["AddressStreet"]}" +
                                                " , " +
                                                "${OrderHistoryList[0]["AddressLandmark"]}" +
                                                " , " +
                                                "${OrderHistoryList[0]["AddressArea"]}",
                                            //"${widget.addressData["AddressStreet"]}",

                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey[700])),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 2.0),
                                        child: Text(
                                            "${OrderHistoryList[0]["AddressCityName"]}" +
                                                " , " +
                                                "${OrderHistoryList[0]["AddressPincode"]}"

                                            // "${widget.addressData["AddressLandmark"]}",
                                            ,
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey[700])),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.call,
                                              color: Colors.grey[700],
                                              size: 19,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5.0),
                                              child: Text(
                                                  "${OrderHistoryList[0]["CustomerPhoneNo"]}",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.grey[700])),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, top: 30),
                        child: Text("Payment Detail",
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 15,
                            )),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 10.0, right: 8, left: 8),
                        // child: GestureDetector(
                        //   onTap: () {
                        //     Navigator.push(
                        //         context,
                        //         FadeRoute(
                        //             page: OrderTab(
                        //           OrderId: OrderHistoryList[0]["OrderId"],
                        //         )));
                        //   },
                        child: Container(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, bottom: 10, right: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0),
                                                child: Text("Order No",
                                                    style: TextStyle(
                                                      color: Colors.grey[700],
                                                      fontSize: 14,
                                                    )),
                                              ),
                                              // Padding(
                                              //   padding: const EdgeInsets.only(top: 8.0),
                                              //   child: Text(":",
                                              //       style: TextStyle(
                                              //         color: Colors.grey[700],
                                              //         fontSize: 14,
                                              //       )),
                                              // ),
                                            ],
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Text(
                                                "${OrderHistoryList[0]["OrderId"]}",
                                                style: TextStyle(
                                                  color: Colors.grey[700],
                                                  fontSize: 14,
                                                )),
                                          ),
                                        ],
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                      ),
                                      Row(
                                        children: [
                                          Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 7.0),
                                                child: Text("Payment Options",
                                                    style: TextStyle(
                                                      color: Colors.grey[700],
                                                      fontSize: 14,
                                                    )),
                                              ),
                                              // Padding(
                                              //   padding: const EdgeInsets.only(top: 3.0),
                                              //   child: Text(":",
                                              //       style: TextStyle(
                                              //         color: Colors.grey[700],
                                              //         fontSize: 14,
                                              //       )),
                                              // ),
                                            ],
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 7.0),
                                            child: Text(
                                                "${OrderHistoryList[0]["OrderPaymentMethod"]}",
                                                style: TextStyle(
                                                  color: Colors.grey[700],
                                                  fontSize: 14,
                                                )),
                                          ),
                                        ],
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                      ),
                                      Row(
                                        children: [
                                          Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 7.0),
                                                child: Text("Sub total",
                                                    style: TextStyle(
                                                      color: Colors.grey[700],
                                                      fontSize: 14,
                                                    )),
                                              ),
                                              // Padding(
                                              //   padding: const EdgeInsets.only(top: 3.0),
                                              //   child: Text(":",
                                              //       style: TextStyle(
                                              //         color: Colors.grey[700],
                                              //         fontSize: 14,
                                              //       )),
                                              // ),
                                            ],
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 7.0),
                                            child: Text(
                                                "${OrderHistoryList[0]["OrderPayment"][0]["SubTotal"]}",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                )),
                                          ),
                                        ],
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                      ),
                                      Row(
                                        children: [
                                          Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 7.0),
                                                child: Text("Delivery charges",
                                                    style: TextStyle(
                                                        color: Colors.grey[700],
                                                        fontSize: 14)),
                                              ),
                                              // Padding(
                                              //   padding: const EdgeInsets.only(top: 8.0),
                                              //   child: Text(":",
                                              //       style: TextStyle(
                                              //         color: Colors.grey[700],
                                              //         fontSize: 14,
                                              //       )),
                                              // ),
                                            ],
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 7.0),
                                            child: Text(
                                                "${OrderHistoryList[0]["OrderPayment"][0]["Deliver Charges"]}",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                )),
                                          ),
                                        ],
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                      ),
                                      Row(
                                        children: [
                                          Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 7.0),
                                                child: Text("Total",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                              ),
                                              // Padding(
                                              //   padding: const EdgeInsets.only(top: 3.0),
                                              //   child: Text(":",
                                              //       style: TextStyle(
                                              //         color: Colors.grey[700],
                                              //         fontSize: 14,
                                              //       )),
                                              // ),
                                            ],
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 7.0),
                                            child: Text(
                                                "${OrderHistoryList[0]["OrderTotal"][0]["Total"]}",
                                                style: TextStyle(
                                                    color: Colors.orange,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        ],
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : NoFoundComponent());
  }
}
