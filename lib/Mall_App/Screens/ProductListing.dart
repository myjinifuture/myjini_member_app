import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_society_new/Mall_App/Common/services.dart';
import 'package:smart_society_new/Mall_App/CustomWidgets/LoadingComponent.dart';
import 'package:smart_society_new/Mall_App/CustomWidgets/NoFoundComponent.dart';
import 'package:smart_society_new/Mall_App/CustomWidgets/ProductComponent.dart';
import 'package:smart_society_new/Mall_App/Screens/FilterScreen.dart';
import 'package:smart_society_new/Mall_App/transitions/slide_route.dart';

class ProductListing extends StatefulWidget {
  var SubCategoryId;
  ProductListing({this.SubCategoryId});
  @override
  _ProductListingState createState() => _ProductListingState();
}

class _ProductListingState extends State<ProductListing> {
  List _Product = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: isLoading == true ? Colors.white : Colors.grey[200],
        appBar: AppBar(
          title: Text("Products"),
        ),
        body: isLoading == true
            ? LoadingComponent()
            : _Product.length > 0
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Items:${_Product.length}',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black54)),
                            FlatButton(
                              color: Colors.white,
                              disabledColor: Colors.grey,
                              disabledTextColor: Colors.black,
                              splashColor: Colors.grey[200],
                              onPressed: () {
                                Navigator.push(context,
                                    SlideLeftRoute(page: FilterScreen()));
                              },
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 6.0),
                                    child: Image.asset('assets/assets/filter.png',
                                        color: Colors.black54, width: 20),
                                  ),
                                  Text(
                                    "Filter",
                                    style: TextStyle(
                                        fontSize: 14.0, color: Colors.black54),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _Product.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ProductComponent(product: _Product[index]);
                            }),
                      ),
                    ],
                  )
                : NoFoundComponent(
                    ImagePath: 'assets/assets/noProduct.png',
                    Title: 'No Product Found',
                  ));
  }

  _getProducts() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        var data =
            FormData.fromMap({"SubcategoryId": '${widget.SubCategoryId}'});
        print(data.fields);
        Services.postforlist(apiname: 'getSubCategoryData', body: data).then(
            (responselist) async {
          if (responselist.length > 0) {
            setState(() {
              _Product = responselist;
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
