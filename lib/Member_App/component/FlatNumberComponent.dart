import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;
import 'package:url_launcher/url_launcher.dart';

class FlatNumberComponent extends StatefulWidget {
  /* var data, advertiserid, advertisementData;

  FlatNumberComponent(this.data, this.advertiserid, this.advertisementData);*/

  @override
  _FlatNumberComponentState createState() => _FlatNumberComponentState();
}

class _FlatNumberComponentState extends State<FlatNumberComponent> {
  ProgressDialog pr;
  bool isLoading = true;
  String mobile;

  @override
  void initState() {
    //getdata();
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

/*  getdata() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    //txtmobile.text = preferences.getString(constant.Session.session_login);
    // txtname.text = preferences.getString(constant.Session.Name);

    print("gg-- " + widget.data.toString());
    print("heythere");
    mobile = widget.advertisementData["AdvertiserMobile"];
    print("heeee-- " + mobile);
  }

  _openWhatsapp(mobile) {
    String whatsAppLink = constant.whatsAppLink;
    String urlwithmobile = whatsAppLink.replaceAll("#mobile", "91$mobile");
    String urlwithmsg = urlwithmobile.replaceAll("#msg", "This is message");
    launch(urlwithmsg);
  }*/

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 50,
            width: 50,
            child: Card(
                borderOnForeground: true,
                color: Colors.grey[200],
                child: Center(
                    child: Text(
                  "A",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ))),
          ),
        ],
      ),
    );
  }
}
