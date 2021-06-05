import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_society_new/Mall_App/Common/services.dart';
import 'package:smart_society_new/Mall_App/CustomWidgets/LoadingComponent.dart';
import 'package:smart_society_new/Mall_App/CustomWidgets/SetFilterComponent.dart';

class SetFilterScreen extends StatefulWidget {
  var filterdata;
  SetFilterScreen({this.filterdata});

  @override
  _SetFilterScreenState createState() => _SetFilterScreenState();
}

class _SetFilterScreenState extends State<SetFilterScreen> {
  bool isFilterLoading = false;
  List SetfilterList = [];

  @override
  void initState() {
    _setFilter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text("Filter Products",
            style: TextStyle(color: Colors.white, fontSize: 18)),
      ),
      body: isFilterLoading == true
          ? LoadingComponent()
          : Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: ListView.separated(
                itemBuilder: (BuildContext context, int index) {
                  return SetFilterComponent(
                    setfilterData: SetfilterList[index],
                  );
                },
                itemCount: SetfilterList.length,
                separatorBuilder: (context, index) {
                  return Container(
                    height: 1,
                    color: Colors.grey[200],
                  );
                },
              ),
            ),
    );
  }

  _setFilter() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        FormData body = FormData.fromMap(widget.filterdata);
        setState(() {
          isFilterLoading = true;
        });
        print(body.fields);
        Services.postforlist(apiname: 'setFilter', body: body).then(
            (responseList) async {
          setState(() {
            isFilterLoading = false;
          });
          if (responseList.length > 0) {
            setState(() {
              SetfilterList = responseList;
            });
          } else {
            Fluttertoast.showToast(msg: "Data Not Found");
          }
        }, onError: (e) {
          setState(() {
            isFilterLoading = false;
          });
          print("error on call -> ${e.message}");
          Fluttertoast.showToast(msg: "Something Went Wrong");
        });
      }
    } on SocketException catch (_) {
      Fluttertoast.showToast(msg: "No Internet Connection.");
    }
  }
}
