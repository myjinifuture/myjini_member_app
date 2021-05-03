import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;

class SocietyRules extends StatefulWidget {
  @override
  _SocietyRulesState createState() => _SocietyRulesState();
}

class _SocietyRulesState extends State<SocietyRules> {
  List RulesData = new List();
  bool isLoading = false;
  String SocietyId;
  bool downloading = false;

  _getLocaldata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SocietyId = prefs.getString(constant.Session.SocietyId);
  }

  @override
  void initState() {
    GetSocietyRules();
    _getLocaldata();
  }

  GetSocietyRules() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });

        Services.GetSocietyRuls(SocietyId).then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data != null && data.length > 0) {
            setState(() {
              RulesData = data;
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
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _downloadFile(String url) async {
    var file = url.split('/');

    Dio dio = Dio();
    try {
      var dir = await getExternalStorageDirectory();
      print("${dir.path}/${file[3].toString()}");
      await dio.download(
          "http://smartsociety.itfuturz.com/${url.replaceAll(" ", "%20")}",
          "${dir.path}/${file[3].toString()}", onReceiveProgress: (rec, total) {
        print("Rec: $rec , Total: $total");
        setState(() {
          downloading = true;
        });
      });
    } catch (e) {
      print(e);
    }
    setState(() {
      downloading = false;
      Fluttertoast.showToast(
          msg: "Download Successfully",
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.green,
          textColor: Colors.white);
    });
  }

  shareFile(String ImgUrl, String Extension) async {
    ImgUrl = ImgUrl.replaceAll(" ", "%20");
    if (ImgUrl.toString() != "null" && ImgUrl.toString() != "") {
      var request = await HttpClient()
          .getUrl(Uri.parse("http://smartsociety.itfuturz.com${ImgUrl}"));
      var response = await request.close();
      Uint8List bytes = await consolidateHttpClientResponseBytes(response);
      await Share.files('Share Rule', {'eyes.$Extension': bytes}, 'image/pdf');
    }
  }

  Widget _SocietyRules(BuildContext context, int index) {
    return Card(
        elevation: 1,
        child: Container(
            child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Image.asset('images/Rules.png', width: 22, height: 22),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        "${RulesData[index]["Title"]}",
                        softWrap: true,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Image.asset('images/Rules.png',
                      width: 22, height: 22, color: Colors.white),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 3.0),
                      child: Text(
                        "${RulesData[index]["Description"]}",
                        softWrap: true,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.visible,
                        //maxLines: 3,
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    _launchURL(Image_Url +
                        "${RulesData[index]["File"]}");
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          color: Colors.grey[200]),
                      child: Center(
                          child: Icon(
                        Icons.remove_red_eye,
                        color: Colors.grey,
                        size: 20,
                      )),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _downloadFile("${RulesData[index]["File"]}");
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          color: Colors.grey[200]),
                      child: Center(
                          child: Icon(
                        Icons.sd_card,
                        color: Colors.grey,
                        size: 20,
                      )),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    var array = RulesData[index]["File"].split(".");
                    print("=============");
                    print(array[1].toString());
                    shareFile("${RulesData[index]["File"]}", array[1]);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          color: Colors.grey[200]),
                      child: Center(
                          child: Icon(
                        Icons.share,
                        color: Colors.black54,
                        size: 20,
                      )),
                    ),
                  ),
                )
              ],
            ),
          ],
        )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Society Rules',
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
          : RulesData.length > 0
              ? ListView.builder(
                  itemBuilder: _SocietyRules, itemCount: RulesData.length)
              : Container(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset("images/NoRules.png",
                            width: 70, height: 70, color: Colors.grey[300]),
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Text("No Rules Found",
                              style: TextStyle(color: Colors.grey[400])),
                        )
                      ],
                    ),
                  ),
                ),
    );
  }
}
