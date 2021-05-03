import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Mall_App/Common/Colors.dart';
import 'package:smart_society_new/Mall_App/Common/Constant.dart';
import 'package:smart_society_new/Mall_App/Common/services.dart';
import 'package:smart_society_new/Mall_App/CustomWidgets/LoadingComponent.dart';
import 'package:smart_society_new/Mall_App/CustomWidgets/NoFoundComponent.dart';
import 'package:smart_society_new/Mall_App/Providers/CartProvider.dart';
import 'package:smart_society_new/Mall_App/Screens/MyCartScreen.dart';
import 'package:smart_society_new/Mall_App/transitions/slide_route.dart';

class ProductDetailScreen extends StatefulWidget {
  var productId;
  ProductDetailScreen({this.productId});
  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool iscartlist = false;
  bool iscartLoading = false;
  bool isLoading = false;
  int currentIndex = 0;
  int currentImageIndex = 0;
  int groupvalue = 0;
  String productDetailId;
  List productdetail = [];
  List packageInfo = [];
  List packageImageList = [];
  String CustomerId;

  getlocaldata() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    CustomerId = await preferences.getString(Session.customerId);
  }

  @override
  void initState() {
    _productDetail();
    getlocaldata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CartProvider provider = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Product Detail",
            style: TextStyle(fontSize: 17, color: Colors.white)),
        actions: [
          Stack(
            children: [
              IconButton(
                  icon: Image.asset('assets/assets/shoppingcart.png',
                      width: 26, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                        context, SlideLeftRoute(page: MyCartScreen()));
                  }),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Container(
                  child: provider.cartCount > 0
                      ? CircleAvatar(
                          radius: 8.0,
                          backgroundColor: Colors.red[400],
                          foregroundColor: Colors.white,
                          child: Text(
                            provider.cartCount.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 11.0,
                            ),
                          ),
                        )
                      : Container(),
                ),
              )
            ],
          )
        ],
      ),
      body: isLoading == true
          ? LoadingComponent()
          : productdetail.length > 0
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 12.0, left: 18.0, right: 10.0),
                      child: Text("${productdetail[0]["ProductName"]}",
                          style: TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0, top: 4.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                                "${packageInfo.length > 0 ? Inr_Rupee + packageInfo[currentIndex]["ProductdetailSRP"] : productdetail[0]["ProductSrp"]}",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: RichText(
                              text: TextSpan(
                                  text: 'MRP: ',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 13),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text:
                                          "${packageInfo.length > 0 ? Inr_Rupee + packageInfo[currentIndex]["ProductdetailMRP"] : productdetail[0]["ProductMrp"]}",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 15,
                                          decoration:
                                              TextDecoration.lineThrough),
                                    )
                                  ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                                height: 250,
                                width: MediaQuery.of(context).size.width,
                                child: Image.network(IMG_URL +
                                    packageImageList[currentImageIndex])),
                            SizedBox(
                              height: 60,
                              child: ListView.builder(
                                  itemCount: packageImageList.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          currentImageIndex = index;
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Container(
                                            height: 55,
                                            width: 55,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 1.0,
                                                    color: index ==
                                                            currentImageIndex
                                                        ? appPrimaryMaterialColor
                                                        : Colors.grey[400]),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(4.0))),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: Image.network(
                                                  '${IMG_URL + packageInfo[currentIndex]["ProductdetailImages"][index]}',
                                                  fit: BoxFit.cover,
                                                  width: 50),
                                            )),
                                      ),
                                    );
                                  }),
                            ),
                            packageInfo.length > 0
                                ? Column(
                                    children: List.generate(packageInfo.length,
                                        (index) {
                                      return InkWell(
                                        onTap: () {
                                          setState(() {
                                            currentIndex = index;
                                            packageImageList =
                                                packageInfo[currentIndex]
                                                    ["ProductdetailImages"];
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 45,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 0.5,
                                                      color: Colors.grey[400]),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              4.0))),
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0,
                                                          right: 6.0),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 6.0),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                                " $Inr_Rupee ${packageInfo[index]["ProductdetailSRP"]}",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    color: Colors
                                                                        .black)),
                                                            RichText(
                                                              text: TextSpan(
                                                                  text: 'MRP: ',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .grey,
                                                                      fontSize:
                                                                          13),
                                                                  children: <
                                                                      TextSpan>[
                                                                    TextSpan(
                                                                      text:
                                                                          "${Inr_Rupee} ${packageInfo[index]["ProductdetailMRP"]}",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .grey,
                                                                          fontSize:
                                                                              13,
                                                                          decoration:
                                                                              TextDecoration.lineThrough),
                                                                    )
                                                                  ]),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 8.0,
                                                                  top: 4.0),
                                                          child: Text(
                                                              "${packageInfo[index]["ProductdetailName"]}",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      13)),
                                                        ),
                                                      ),
                                                      currentIndex == index
                                                          ? Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      right:
                                                                          8.0),
                                                              child: Icon(
                                                                  Icons
                                                                      .radio_button_checked,
                                                                  size: 20),
                                                            )
                                                          : Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      right:
                                                                          8.0),
                                                              child: Icon(
                                                                  Icons
                                                                      .radio_button_unchecked,
                                                                  size: 20),
                                                            )
                                                    ],
                                                  ))),
                                        ),
                                      );
                                    }),
                                  )
                                : Container(),
                            SizedBox(
                              height: 8,
                            ),
                            Container(
                              height: 15,
                              color: Colors.grey[100],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Text('Product Description',
                                  style: TextStyle(fontSize: 16)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, right: 8.0, bottom: 8.0),
                              child: Text(
                                "${productdetail[0]["ProductDescription"]}",
                                style: TextStyle(color: Colors.black54),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                )
              : NoFoundComponent(),
      bottomNavigationBar: Container(
        height: 50,
        color: Colors.red[400],
        child: GestureDetector(
          onTap: () {
            _addTocart();
            /* if (provider.cartIdList.contains(int.parse(widget.productId))) {
              Navigator.push(context, SlideLeftRoute(page: MyCartScreen()));
            } else {

            }*/
          },
          child: iscartLoading
              ? Center(
                  child: SpinKitRipple(
                  color: Colors.white,
                ))
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/assets/shoppingcart.png',
                        width: 26, color: Colors.white),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child:
                          /*provider.cartIdList
                              .contains(int.parse(widget.productId))
                          ? Text("Already in cart",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold))
                          : */
                          Text("Add to cart",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
        ),
      ),
    );
  }

  _productDetail() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var data = FormData.fromMap({"ProductId": "${widget.productId}"});
        print(data.fields);
        setState(() {
          isLoading = true;
        });
        Services.postforlist(apiname: 'getProductDetailDataTest', body: data)
            .then((responselist) async {
          if (responselist.length > 0) {
            setState(() {
              isLoading = false;
              productdetail = responselist;
              packageInfo = responselist[1]["PackInfo"];
              packageImageList = responselist[1]["PackInfo"][currentIndex]
                  ["ProductdetailImages"];
            });
            print("Package Image List$packageImageList");
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
          "ProductId": "${productdetail[0]["ProductId"]}",
          "CartQuantity": "1",
          "ProductDetailId": "${packageInfo[currentIndex]["ProductdetailId"]}"
        });
        print(body.fields);
        Services.postForSave(apiname: 'addToCart', body: body).then(
            (responseadd) async {
          if (responseadd.IsSuccess == true && responseadd.Data == "1") {
            setState(() {
              iscartLoading = false;
              iscartlist = !iscartlist;
            });
            Navigator.push(context, SlideLeftRoute(page: MyCartScreen()));
            Provider.of<CartProvider>(context, listen: false).increaseCart(
                productId: int.parse(productdetail[0]["ProductId"]));
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
