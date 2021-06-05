import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;
import 'package:smart_society_new/Member_App/common/join.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibration/vibration.dart';

class SOS extends StatefulWidget {
  var data;
  var body;
  bool isButtonPressed;

  SOS(this.data, {this.body,this.isButtonPressed});

  @override
  _SOSState createState() => _SOSState();
}

class _SOSState extends State<SOS> {
  List NoticeData = new List();
  bool isLoading = false;

  String SocietyId;

  int selected_Index;
  var mydata;

  @override
  void initState() {
    Vibration.cancel();
    print("widget.data");
    print(widget.data);
  }

  showHHMsg(String title, String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(title),
          content: new Text(msg),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/HomeScreen', (route) => false);              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushNamedAndRemoveUntil(
            context, '/HomeScreen', (route) => false);      },
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Image.asset(
                'images/background.png',
                fit: BoxFit.fill,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  child: contentBox(context),
                ),
                Image.asset(
                  'images/myginitext.png',
                  height: 60,
                ),
              ],
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/HomeScreen', (route) => false);},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  contentBox(context) {
    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 20, top: 65, right: 20, bottom: 20),
          margin: EdgeInsets.only(top: 65),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 5), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Text(
                widget.body,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
              ),
              Text(
                "Sent By ${widget.data["Name"]}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: constant.appPrimaryMaterialColor,
                ),
              ),
              widget.data["SendBy"] == "Watchman" ? Text(
                "${widget.data["WatchmanWing"]}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: constant.appPrimaryMaterialColor,
                ),
              ):Text(
                "${widget.data["SenderWing"]}-${widget.data["SenderFlat"]}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: constant.appPrimaryMaterialColor,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      launch("tel:" + widget.data["ContactNo"]);
                    },
                    child: Column(
                      children: <Widget>[
                        Image.asset('images/telephone.png',
                            width: 40, height: 40),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                ],
              ),
              RaisedButton(
                color: Colors.white,
                child:  Text('Check Location',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                onPressed: (){
                  launch(widget.data["GoogleMap"]);
                },
              ),
              SizedBox(
                height: 30,
              )
            ],
          ),
        ),
        widget.data["Image"] == null || widget.data["Image"] == ""
            ? Positioned(
                left: 20,
                right: 20,
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 65,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(65),
                        ),
                        child: Image.asset(
                          "images/user.png",
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Positioned(
                left: 20,
                right: 20,
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 65,
                  backgroundImage: NetworkImage(
                    constant.Image_Url + "${widget.data["Image"]}",
                  ),
                ),
              ),
        //company image
        // Positioned(
        //   top: 80,
        //   left: 20,
        //   right: -180,
        //   child: CircleAvatar(
        //     backgroundColor: Colors.transparent,
        //     // maxRadius: 30,
        //     radius: 30,
        //     child: Container(
        //       // height: 60,
        //       // width: 60,
        //       child: Image.network(
        //         constant.Image_Url + '${widget.data["CompanyImage"]}',
        //         width: 60,
        //         height: 60,
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }

}
