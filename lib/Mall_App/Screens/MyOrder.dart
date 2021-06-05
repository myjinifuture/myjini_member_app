import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Mall_App/Common/Constant.dart';
import 'package:smart_society_new/Mall_App/Common/services.dart';
import 'package:smart_society_new/Mall_App/CustomWidgets/LoadingComponent.dart';
import 'package:smart_society_new/Mall_App/CustomWidgets/MyOrderComponent.dart';
import 'package:smart_society_new/Mall_App/CustomWidgets/NoFoundComponent.dart';

class MyOrder extends StatefulWidget {
  @override
  _MyOrderState createState() => _MyOrderState();
}

class _MyOrderState extends State<MyOrder> {
  List MyOrderList = [];
  String CustomerId;
  bool isorderDetailLoading = false;

  @override
  void initState() {
    setState(() {
      _MyOrder();
      getlocaldata();
    });
  }

  getlocaldata() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    CustomerId = await preferences.getString(Session.customerId);
  }

  _MyOrder() async {
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
              MyOrderList = responselist;
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        title: Text("My Order",
            style: TextStyle(color: Colors.white, fontSize: 18)),
      ),
      body: isorderDetailLoading == true
          ? LoadingComponent()
          : MyOrderList.length > 0
              ? ListView.separated(
                  padding: EdgeInsets.only(top: 10),
                  physics: BouncingScrollPhysics(),
                  itemCount: MyOrderList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return MyorderComponent(
                      MyOrderData: MyOrderList[index],
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      Container(
                    color: Colors.white,
                    height: 10,
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    NoFoundComponent(
                      ImagePath: 'assets/assets/noProduct.png',
                      Title: "No Data Found",
                    ),
                  ],
                ),
    );
  }
}
