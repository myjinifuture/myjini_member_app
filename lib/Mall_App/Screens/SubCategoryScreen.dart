import 'dart:io';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_society_new/Mall_App/Common/Constant.dart';
import 'package:smart_society_new/Mall_App/CustomWidgets/LoadingComponent.dart';
import 'package:smart_society_new/Mall_App/Common/services.dart';
import 'package:smart_society_new/Mall_App/CustomWidgets/SubCategoryComponent.dart';
import 'package:smart_society_new/Mall_App/CustomWidgets/TitlePattern.dart';

class SubCategoryScreen extends StatefulWidget {
  var categoryId;
  SubCategoryScreen({this.categoryId});
  @override
  _SubCategoryScreenState createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  bool isLoading = false;
  List _subCategory = [];
  List _bannerList = [];
  List dataList = [];

  @override
  void initState() {
    _getSubCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isLoading == true ? Colors.white : Colors.grey[400],
      appBar: AppBar(
        centerTitle: true,
        title: Text("SubCategory",
            style: TextStyle(color: Colors.white, fontSize: 18)),
      ),
      body: isLoading == true
          ? LoadingComponent()
          : dataList.length > 0
              ? SingleChildScrollView(
                  child: Column(
                  children: [
                    SizedBox(
                      height: 170.0,
                      width: MediaQuery.of(context).size.width,
                      child: _bannerList.length > 0
                          ? Carousel(
                              boxFit: BoxFit.cover,
                              autoplay: true,
                              animationCurve: Curves.fastOutSlowIn,
                              animationDuration: Duration(milliseconds: 1000),
                              dotSize: 4.0,
                              dotIncreasedColor: Colors.black54,
                              dotBgColor: Colors.transparent,
                              dotPosition: DotPosition.bottomCenter,
                              dotVerticalPadding: 10.0,
                              showIndicator: true,
                              indicatorBgPadding: 7.0,
                              images: _bannerList
                                  .map((item) => Container(
                                      child: Image.network(
                                          IMG_URL + item["BannerImage"],
                                          fit: BoxFit.fill)))
                                  .toList(),
                            )
                          : Container(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 4.0, right: 4.0, top: 4.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                            child: TitlePattern(title: "Shop by SubCategory")),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                      child: Card(
                        child: GridView.builder(
                          shrinkWrap: true,
                          itemCount: _subCategory.length,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                          ),
                          itemBuilder: (context, index) {
                            return SubCategoryComponent(_subCategory[index]);
                          },
                        ),
                      ),
                    ),
                  ],
                ))
              : Container(
                  child: Image.asset('assets/assets/noProduct.png'),
                ),
    );
  }

  _getSubCategory() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var data =
            FormData.fromMap({"CategoryId": "${widget.categoryId.toString()}"});
        print("CategoryId");
        setState(() {
          isLoading = true;
        });
        Services.postforlist(apiname: 'getCategoryData', body: data).then(
            (responselist) async {
          if (responselist.length > 0) {
            setState(() {
              dataList = responselist;
              _bannerList = responselist[0]["Banner"];
              _subCategory = responselist[1]["SubCategory"];
              isLoading = false;
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
          print("error on call -> ${e.message}");
          Fluttertoast.showToast(msg: "something went wrong");
        });
      }
    } on SocketException catch (_) {
      Fluttertoast.showToast(msg: "No Internet Connection");
    }
  }
}
