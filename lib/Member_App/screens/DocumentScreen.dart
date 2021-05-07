import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;
import 'package:smart_society_new/Member_App/common/constant.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';

class DocumentScreen extends StatefulWidget {
  @override
  _DocumentScreenState createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  List DocumentData = new List();
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

  String setDate(String date) {
    String final_date = "";
    var tempDate;
    if (date != "" || date != null) {
      tempDate = date.toString().split("-");
      if (tempDate[2].toString().length == 1) {
        tempDate[2] = "0" + tempDate[2].toString();
      }
      if (tempDate[1].toString().length == 1) {
        tempDate[1] = "0" + tempDate[1].toString();
      }
      final_date = date == "" || date == null
          ? ""
          : "${tempDate[2].toString().substring(0, 2)}-${tempDate[1].toString()}-${tempDate[0].toString()}"
              .toString();
    }

    return final_date;
  }

  GetSocietyRules() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        var data = {
          "societyId" : SocietyId
        };
        Services.responseHandler(apiName: "admin/getSocietyDocs",body: data).then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data.Data != null && data.Data.length > 0) {
            setState(() {
              // DocumentData = data.Data;
              for(int i=data.Data.length-1;i>=0;i--){
                DocumentData.add(data.Data[i]);
              }
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
                Navigator.pushNamedAndRemoveUntil(
                    context, '/HomeScreen', (route) => false);              },
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
    FlutterDownloader.initialize();
    var dir=await getApplicationDocumentsDirectory();
    await FlutterDownloader.enqueue(
      url: url,
      savedDir: "${dir.path}/${file}.jpg",
      showNotification: true, // show download progress in status bar (for Android)
      openFileFromNotification: true, // click on notification to open downloaded file (for Android)
    );
    //
    // Dio dio = Dio();
    // try {
    //   var dir = await getExternalStorageDirectory();
    //   print("${dir.path}/${file[3].toString()}");
    //   await dio.download(
    //       "http://smartsociety.itfuturz.com/${url.replaceAll(" ", "%20")}",
    //       "${dir.path}/${file[3].toString()}", onReceiveProgress: (rec, total) {
    //     print("Rec: $rec , Total: $total");
    //     setState(() {
    //       downloading = true;
    //     });
    //   });
    // } catch (e) {
    //   print(e);
    // }
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
      await Share.files(
          'Share Document', {'eyes.$Extension': bytes}, 'image/pdf');
    }
  }

  Widget _SocietyDocument(BuildContext context, int index) {
    return AnimationConfiguration.staggeredList(
      position: index,
      child: SlideAnimation(
        verticalOffset: -100,
        duration: const Duration(milliseconds: 375),
        child: FadeInAnimation(
          child: Card(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Row(
                    children: <Widget>[
                      Image.asset("images/file.png",
                          height: 20, width: 20, color: Colors.grey),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "${DocumentData[index]["Title"]}",
                                softWrap: true,
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                              Text(DocumentData[index]["dateTime"][0],
                              )],
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
                            "${DocumentData[index]["FileAttachment"]}");
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100)),
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
                    // GestureDetector(
                    //   onTap: () {
                    //     _downloadFile("${DocumentData[index]["FileAttachment"]}");
                    //   },
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(6.0),
                    //     child: Container(
                    //       width: 35,
                    //       height: 35,
                    //       decoration: BoxDecoration(
                    //           borderRadius:
                    //               BorderRadius.all(Radius.circular(100)),
                    //           color: Colors.grey[200]),
                    //       child: Center(
                    //           child: Icon(
                    //         Icons.sd_card,
                    //         color: Colors.grey,
                    //         size: 20,
                    //       )),
                    //     ),
                    //   ),
                    // ),
                    GestureDetector(
                      onTap: () {
                        print(constant.Image_Url + DocumentData[index]["FileAttachment"]);
                        var array = DocumentData[index]["FileAttachment"].split(".");
                        launch("${constant.Image_Url + DocumentData[index]["FileAttachment"]}"); // ask monil to make changes 6 - number - FileAttachment
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100)),
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
          centerTitle: true,
          title: Text(
            'Documents',
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
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : DocumentData.length > 0
                ? AnimationLimiter(
                    child: ListView.builder(
                        itemBuilder: _SocietyDocument,
                        itemCount: DocumentData.length),
                  )
                : Container(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset("images/file.png",
                              width: 70, height: 70, color: Colors.grey[300]),
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Text("No Document Found",
                                style: TextStyle(color: Colors.grey[400])),
                          )
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }
}
