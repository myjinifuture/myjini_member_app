import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;
import 'package:smart_society_new/Member_App/screens/DirectoryScreen.dart';

class WingListItem extends StatefulWidget {
  @override
  _WingListItemState createState() => _WingListItemState();
}

class _WingListItemState extends State<WingListItem> {
  bool isLoading = false;
  List WingData = new List();
  String SocietyId;

  _getLocaldata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SocietyId = prefs.getString(constant.Session.SocietyId);
  }

  @override
  void initState() {
    _getLocaldata();
    GetWingList();
  }

  GetWingList() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });

        Services.GetWingData(SocietyId).then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data != null && data.length > 0) {
            setState(() {
              WingData = data;
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
          showHHMsg("Try Again.", "");
        });
      }
    } on SocketException catch (_) {
      showHHMsg("No Internet Connection.", "");
    }
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
                Navigator.of(context).pop();;
              },
            ),
          ],
        );
      },
    );
  }

  Widget _WinglistName(BuildContext context, int index) {
    return AnimationConfiguration.staggeredGrid(
      columnCount: 3,
      child: SlideAnimation(
        verticalOffset: 100,
        child: FadeInAnimation(
          child: GestureDetector(
            onTap: () {
              /*Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DirecotryScreen(
                            wingType: "${WingData[index]["WingName"]}",
                            wingId: "${WingData[index]["Id"]}",
                          )));*/
            },
            child: Card(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text("${WingData[index]["WingName"]}",
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(81, 92, 111, 1))),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        "Wing",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushNamedAndRemoveUntil(
            context, '/HomeScreen', (route) => false);      },
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/HomeScreen', (route) => false);                }),
            centerTitle: true,
            title: Text(
              "Directory",
              style: TextStyle(fontSize: 18),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(10),
              ),
            ),
          ),
          body: isLoading
              ? Container(
                  child: Center(child: CircularProgressIndicator()),
                )
              : WingData.length > 0
                  ? Container(
                      color: Colors.grey[100],
                      height: MediaQuery.of(context).size.height,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: AnimationLimiter(
                          child: GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: WingData.length,
                              itemBuilder: _WinglistName,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: MediaQuery.of(context)
                                        .size
                                        .width /
                                    (MediaQuery.of(context).size.height / 2.3),
                              )),
                        ),
                      ),
                    )
                  : Center(
                      child: Container(
                      child: Text("No Data Found"),
                    ))),
    );
  }
}
