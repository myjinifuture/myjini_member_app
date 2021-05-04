import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Member_App/Services/ProductList.dart';
import 'package:smart_society_new/Member_App/Services/ProductList.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as cnst;

class MyWishListComponent extends StatefulWidget {
  var WishList;
  Function _onremove;

  MyWishListComponent(this.WishList,this._onremove);

  @override
  _MyWishListComponentState createState() => _MyWishListComponentState();
}

class _MyWishListComponentState extends State<MyWishListComponent> {
  ProgressDialog pr;


  @override
  void initState() {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
        message: "Please Wait",
        borderRadius: 10.0,
        progressWidget: Container(
          padding: EdgeInsets.all(15),
          child: CircularProgressIndicator(
            valueColor:
            AlwaysStoppedAnimation<Color>(cnst.appPrimaryMaterialColor),
          ),
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w600));
    // TODO: implement initState
    super.initState();
  }

  void _showConfirmDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // title: new Text("MyJINI"),
          content: new Text("Are You Sure You Want To Remove This ?"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("No",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600)),
              onPressed: () {
                Navigator.of(context).pop();;
              },
            ),
            new FlatButton(
              child: new Text("Yes",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600)),
              onPressed: () {
                Navigator.of(context).pop();;
                _wishListDelete();
              },
            ),
          ],
        );
      },
    );
  }

  _wishListDelete() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var data = {
          "AdvertisementId": widget.WishList["Id"].toString(),
          "MemberId": prefs.getString(cnst.Session.Member_Id),
        };

        print("WishList Delete Data = ${data}");
        Services.WishListDelete(data).then((data) async {
          if (data.Data != "0" && data.IsSuccess == true) {
          //  _checkWishList();
            Fluttertoast.showToast(
                textColor: Colors.black,
                msg: "Removed From WishList",
                gravity: ToastGravity.TOP,
                toastLength: Toast.LENGTH_LONG);

            widget._onremove();

            //Navigator.pop(context);
             /* Navigator.pushNamedAndRemoveUntil(
                context, "/MyWishList", (Route<dynamic> route) => false);*/
          } else {
            showMsg(data.Message, title: "Error");
          }
        }, onError: (e) {
          showMsg("Try Again.");
        });
      } else
        showMsg("No Internet Connection.");
    } on SocketException catch (_) {
      // pr.hide();
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
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          children: <Widget>[
            widget.WishList["Image"] != "" &&
                widget.WishList["Image"] != null
                ? FadeInImage.assetNetwork(
                placeholder: "images/Ad1.jpg",
                width: MediaQuery.of(context).size.width,
                height: 150,
                fit: BoxFit.fill,
                image: "${cnst.Image_Url}" + widget.WishList["Image"])
                : Image.asset(
              "images/Ad1.jpg",
              width: MediaQuery.of(context).size.width,
              height: 150,
              fit: BoxFit.fill,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top:8.0,bottom: 4.0),
                  child: Text(
                    "${widget.WishList["Title"]}",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top:8.0,bottom: 4.0,left: 8.0),
                    child: Text(
                      "Offer By - ${widget.WishList["AdvertiserName"]} ",
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right:8.0,bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      _showConfirmDialog();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
