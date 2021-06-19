import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;

class Statistics extends StatefulWidget {
  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  bool isLoading = false;
  List NewList = [];
  @override
  void initState() {
    // getSocietyStatistics(); // ask monil to make service for statistics - 8 number
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
        centerTitle: true,
        title: Text('Statistics', style: TextStyle(fontSize: 18)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        ),
      ),
      body: isLoading == false
          ? NewList.length == 0 ? Center(
          child: Text(
            "No Data Found",
            style: TextStyle(
                color: Colors.grey, fontWeight: FontWeight.w500),
          )):Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Flexible(
                      child: Card(
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2,
                          height: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "${NewList[0]['ActiveMember']}",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: constant.appPrimaryMaterialColor,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                "Active Members",
                                style: TextStyle(
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Card(
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2,
                          height: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "${NewList[0]['Totalmember']}",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: constant.appPrimaryMaterialColor,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                "Total Population",
                                style: TextStyle(
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // Row(
                //   children: <Widget>[
                //     Flexible(
                //       child: Card(
                //         child: Container(
                //           width: MediaQuery.of(context).size.width / 2,
                //           height: 100,
                //           child: Column(
                //             mainAxisAlignment: MainAxisAlignment.center,
                //             children: <Widget>[
                //               Text(
                //                 "152",
                //                 style: TextStyle(
                //                     fontSize: 20,
                //                     color: constant.appPrimaryMaterialColor,
                //                     fontWeight: FontWeight.w600),
                //               ),
                //               SizedBox(
                //                 height: 8,
                //               ),
                //               Text(
                //                 "Total Adults",
                //                 style: TextStyle(
                //                   fontSize: 13,
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ),
                //       ),
                //     ),
                //     Flexible(
                //       child: Card(
                //         child: Container(
                //           width: MediaQuery.of(context).size.width / 2,
                //           height: 100,
                //           child: Column(
                //             mainAxisAlignment: MainAxisAlignment.center,
                //             children: <Widget>[
                //               Text(
                //                 "75",
                //                 style: TextStyle(
                //                     fontSize: 20,
                //                     color: constant.appPrimaryMaterialColor,
                //                     fontWeight: FontWeight.w600),
                //               ),
                //               SizedBox(
                //                 height: 8,
                //               ),
                //               Text(
                //                 "Total Children",
                //                 style: TextStyle(
                //                   fontSize: 13,
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                Row(
                  children: <Widget>[
                    Flexible(
                      child: Card(
                        child: Container(
                          height: 70,
                          width: MediaQuery.of(context).size.width / 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Image.asset(
                                "images/automobile.png",
                                width: 40,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "${NewList[0]['FourWheeler']}",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: constant.appPrimaryMaterialColor,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    "Car",
                                    style: TextStyle(
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Card(
                        child: Container(
                          height: 70,
                          width: MediaQuery.of(context).size.width / 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Image.asset(
                                "images/bike.png",
                                width: 40,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "${NewList[0]['TwoWheeler']}",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: constant.appPrimaryMaterialColor,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    "Bike",
                                    style: TextStyle(
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
