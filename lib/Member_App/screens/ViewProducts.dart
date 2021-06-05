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
