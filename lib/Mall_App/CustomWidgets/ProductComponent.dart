import 'dart:developer';

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Mall_App/Common/Constant.dart';
import 'package:smart_society_new/Mall_App/Common/services.dart';
import 'package:smart_society_new/Mall_App/Providers/CartProvider.dart';
import 'package:smart_society_new/Mall_App/Screens/ProductDetailScreen.dart';

class ProductComponent extends StatefulWidget {
  var product;

  ProductComponent({this.product});

  @override
  _ProductComponentState createState() => _ProductComponentState();
}

class _ProductComponentState extends State<ProductComponent> {
  List iscartlist;
  bool iscartLoading = false;
  String CustomerId;
  List packageInfo = [];
  int currentIndex = 0;

  getlocaldata() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    CustomerId = await preferences.getString(Session.customerId);
  }

  getPackageInfo() {
    setState(() {
      packageInfo = widget.product["PackInfo"];
    });
    print(
        "Packages ${widget.product["ProductId"]}---------------${packageInfo.length}");
  }

  @override
  void initState() {
    getlocaldata();
    getPackageInfo();
  }

  int Qty = 0;

  void add() {
    setState(() {
      Qty++;
    });
  }

  void remove() {
    if (Qty != 0) {
      setState(() {
        Qty--;
      });
    }
  }

  showPackageInfo() {
    showDialog(
        builder: (context) => Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text("Pack Variation",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Divider(),
              Column(
                  children: List.generate(packageInfo.length, (index) {
                return InkWell(
                    onTap: () {
                      setState(() {
                        currentIndex = index;
                      });
                      Navigator.of(context).pop();;
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 6.0, bottom: 6.0),
                          child: Column(
                            children: [
                              Text(
                                  " ${packageInfo[index]["ProductdetailName"]}",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.black)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                        text: 'MRP: ',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 14),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text:
                                                "${packageInfo[index]["ProductdetailMRP"]}",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 15,
                                                decoration:
                                                    TextDecoration.lineThrough),
                                          )
                                        ]),
                                  ),
                                  Text(
                                      " ${packageInfo[index]["ProductdetailSRP"]}",
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.black)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 0.5,
                          color: Colors.grey[200],
                        )
                      ],
                    ));
              }))
            ],
          ),
        ), context: context);
  }

  @override
  Widget build(BuildContext context) {
    CartProvider provider = Provider.of<CartProvider>(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProductDetailScreen(
                    productId: widget.product["ProductId"],
                  )),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 1),
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 8.0, bottom: 8, left: 4, right: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.product["PackInfo"][0]["ProductdetailImages"][0] !=
                            ""
                        ? Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Image.network(
                              '${IMG_URL + widget.product["PackInfo"][0]["ProductdetailImages"][0]}',
                              width: 120,
                              height: 120,
                            ),
                          )
                        : Image.asset(
                            'assets/no-image.png',
                            width: 120,
                            height: 120,
                          ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "${widget.product["ProductName"]}",
                              style: TextStyle(fontSize: 15),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              "${widget.product["SubcategoryName"]}",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: InkWell(
                                onTap: () {
                                  showPackageInfo();
                                },
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Center(
                                      child: Text(
                                          "${packageInfo[currentIndex]["ProductdetailName"]}",
                                          style: TextStyle(fontSize: 10)),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(4.0)),
                                      border: Border.all(
                                          width: 1, color: Colors.grey)),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: RichText(
                                text: TextSpan(
                                    text: '${Inr_Rupee}: ',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 15),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text:
                                            "${packageInfo[currentIndex]["ProductdetailMRP"]}",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 15,
                                            decoration:
                                                TextDecoration.lineThrough),
                                      )
                                    ]),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 2.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      " ${Inr_Rupee + packageInfo[currentIndex]["ProductdetailSRP"]}",
                                      style: TextStyle(
                                          fontSize: 17, color: Colors.black)),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: SizedBox(
                                      height: 35,
                                      width: 75,
                                      child: FlatButton(
                                        onPressed: () {
                                          _addTocart();
                                          /*if (provider.cartIdList.contains(
                                              int.parse(widget
                                                  .product["ProductId"]))) {
                                            Fluttertoast.showToast(
                                                msg: "Already in Cart!");
                                          } else {
                                            _addTocart();
                                          }*/
                                        },
                                        color: Colors.redAccent,
                                        child: iscartLoading == true
                                            ? Container(
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height,
                                                child: Center(
                                                    child: SpinKitCircle(
                                                  color: Colors.white,
                                                  size: 25,
                                                )),
                                              )
                                            :
                                            /*provider.cartIdList.contains(
                                                    int.parse(widget
                                                        .product["ProductId"]))*/
                                            Text('Add',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15)),
                                      ),
                                    ),
                                  ),

                                  // : Padding(
                                  //     padding:
                                  //         const EdgeInsets.only(right: 10.0),
                                  //     child: Row(
                                  //       children: [
                                  //         InkWell(
                                  //           child: Container(
                                  //             decoration: BoxDecoration(
                                  //                 color: Colors.white,
                                  //                 boxShadow: [
                                  //                   BoxShadow(
                                  //                     color: Colors.grey[300],
                                  //                     blurRadius: 2.0,
                                  //                   ),
                                  //                 ],
                                  //                 borderRadius:
                                  //                     BorderRadius.circular(
                                  //                         4.0),
                                  //                 border: Border.all(
                                  //                     width: 1,
                                  //                     color:
                                  //                         Colors.red[400])),
                                  //             width: 30,
                                  //             height: 30,
                                  //             child: Center(
                                  //               child: Icon(Icons.remove,
                                  //                   color: Colors.red[400],
                                  //                   size: 20),
                                  //             ),
                                  //           ),
                                  //           onTap: () {
                                  //             remove();
                                  //           },
                                  //         ),
                                  //         Padding(
                                  //           padding: const EdgeInsets.only(
                                  //               left: 10.0, right: 10.0),
                                  //           child: Text(
                                  //             "${Qty}",
                                  //             style: TextStyle(fontSize: 20),
                                  //           ),
                                  //         ),
                                  //         InkWell(
                                  //           onTap: () {
                                  //             add();
                                  //           },
                                  //           child: Container(
                                  //             decoration: BoxDecoration(
                                  //                 color: Colors.white,
                                  //                 boxShadow: [
                                  //                   BoxShadow(
                                  //                     color: Colors.grey[300],
                                  //                     blurRadius: 2.0,
                                  //                   ),
                                  //                 ],
                                  //                 borderRadius:
                                  //                     BorderRadius.circular(
                                  //                         4.0),
                                  //                 border: Border.all(
                                  //                     width: 1,
                                  //                     color:
                                  //                         Colors.red[400])),
                                  //             width: 30,
                                  //             height: 30,
                                  //             child: Center(
                                  //               child: Icon(Icons.add,
                                  //                   color: Colors.red[400],
                                  //                   size: 20),
                                  //             ),
                                  //           ),
                                  //         )
                                  //       ],
                                  //     ),
                                  //   ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _addTocart() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          iscartLoading = true;
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        FormData body = FormData.fromMap({
          "CustomerId": CustomerId,
          "ProductId": "${widget.product["ProductId"]}",
          "CartQuantity": "1",
          "ProductDetailId": "${packageInfo[currentIndex]["ProductdetailId"]}",
        });
        print(body.fields);
        Services.postForSave(apiname: 'addToCart', body: body).then(
            (responseadd) async {
          if (responseadd.IsSuccess == true && responseadd.Data == "1") {
            // Navigator.push(context, FadeRoute(page: MyCartScreen()));
            setState(() {
              iscartLoading = false;
            });
            Provider.of<CartProvider>(context, listen: false).increaseCart(
                productId: int.parse(widget.product["ProductId"]));
            Fluttertoast.showToast(
                msg: "Added Successfully", gravity: ToastGravity.BOTTOM);
          }
        }, onError: (e) {
          setState(() {
            iscartLoading = false;
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
