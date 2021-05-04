import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/component/ViewProductsComponent.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as cnst;

class ViewProducts extends StatefulWidget {
  var data;

  ViewProducts(this.data);

  @override
  _ViewProductsState createState() => _ViewProductsState();
}

class _ViewProductsState extends State<ViewProducts> {
  List ProductList = [];
  ProgressDialog pr;
  bool isLoading = true;

  @override
  void initState() {
    print("gg-- " + widget.data.toString());
    _getProductList();
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
        message: "Please Wait..",
        borderRadius: 10.0,
        progressWidget: Container(
          padding: EdgeInsets.all(15),
          child: CircularProgressIndicator(
              //backgroundColor: cnst.appPrimaryMaterialColor,
              ),
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w600));
  }

  _getProductList() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        String id = widget.data["AdvertiserId"].toString();
        Future res = Services.GetProduct(id);
        setState(() {
          isLoading = true;
        });
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              ProductList = data;
              isLoading = false;
            });
            print("Helo=> " + ProductList.toString());
            print("Helo=> " + ProductList.length.toString());
          } else {
            setState(() {
              ProductList = [];
              isLoading = false;
            });
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          print("Error : on GetAd Data Call $e");
          showMsg("$e");
        });
      } else {
        showMsg("Something went Wrong!");
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
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
        title: Text("View Product"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          isLoading
              ? Center(child: CircularProgressIndicator())
              : ProductList.length > 0
                  ? Expanded(
                      child: StaggeredGridView.countBuilder(
                          crossAxisCount: 4,
                          itemCount: ProductList.length,
                          staggeredTileBuilder: (_) => StaggeredTile.fit(2),
                          itemBuilder: (BuildContext context, int index) {
                            return ViewProductsComponent(ProductList[index],
                                widget.data["AdvertiserId"], widget.data);
                          }),
                    )
                  : Center(
                      child: Text(
                      "No Products Found",
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          fontSize: 17),
                    ))
        ],
      ),
    );
  }
}
