import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_society_new/Mall_App/Common/services.dart';
import 'package:smart_society_new/Mall_App/CustomWidgets/LoadingComponent.dart';
import 'package:smart_society_new/Mall_App/CustomWidgets/NoFoundComponent.dart';
import 'package:smart_society_new/Mall_App/CustomWidgets/OrderDetailComponent.dart';

class OrderDetailScreen extends StatefulWidget {
  var orderid;
  OrderDetailScreen({this.orderid});

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  List OrderDetailList = [];
  String CustomerId;
  bool isorderLoading = false;

  @override
  void initState() {
    _getorderhistorydetail();
    print(widget.orderid);
  }

  _getorderhistorydetail() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isorderLoading = true;
        });
        FormData body = FormData.fromMap({"OrderId": widget.orderid});
        print(body.fields);
        Services.postforlist(apiname: 'orderHistoryDetail', body: body).then(
            (responselist) async {
          setState(() {
            isorderLoading = false;
          });
          if (responselist.length > 0) {
            setState(() {
              OrderDetailList = responselist;
            });
          } else {
            Fluttertoast.showToast(msg: "Data Not Found!");
          }
        }, onError: (e) {
          setState(() {
            isorderLoading = false;
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
        backgroundColor: Colors.grey[100],
        // appBar: AppBar(
        //   elevation: 1,
        //   title: Text("Order Detail",
        //       style: TextStyle(color: Colors.white, fontSize: 18)),
        // ),
        body: isorderLoading
            ? LoadingComponent()
            : OrderDetailList.length > 0
                ? Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: ListView.separated(
                      physics: BouncingScrollPhysics(),
                      itemCount: OrderDetailList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return OrderDetailComponent(
                          orderDetaildata: OrderDetailList[index],
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          Divider(),
                    ),
                  )
                : NoFoundComponent());
  }
}
