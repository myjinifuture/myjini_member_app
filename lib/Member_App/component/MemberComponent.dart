import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:smart_society_new/Admin_App/Screens/MemberProfile.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:smart_society_new/Admin_App/Common/Constants.dart' as cnst;
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';

class MemberComponent extends StatefulWidget {
  var memberData;

  int index;

  MemberComponent(this.memberData, this.index);

  @override
  _MemberComponentState createState() =>
      _MemberComponentState();
}

class _MemberComponentState extends State<MemberComponent> {
  _openWhatsapp(mobile) {
    String whatsAppLink = cnst.whatsAppLink;
    String urlwithmobile = whatsAppLink.replaceAll("#mobile", "91$mobile");
    String urlwithmsg = urlwithmobile.replaceAll("#msg", "");
    launch(urlwithmsg);
  }

  shareFile(String ImgUrl) async {
    ImgUrl = ImgUrl.replaceAll(" ", "%20");
    if (ImgUrl.toString() != "null" && ImgUrl.toString() != "") {
      var request = await HttpClient()
          .getUrl(Uri.parse("http://smartsociety.itfuturz.com/${ImgUrl}"));
      var response = await request.close();
      Uint8List bytes = await consolidateHttpClientResponseBytes(response);
      await Share.files('Share Profile', {'eyes.vcf': bytes}, 'image/pdf');
    }
  }

  bool isLoading = false;
  String Data = "";

  GetVcard() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });

        Services.GetVcardofMember(widget.memberData["SocietyData"][0]['_id'].toString()).then(
                (data) async {
              setState(() {
                isLoading = false;
              });
              if (data != null) {
                setState(() {
                  Data = data;
                });
                shareFile('${Data}');
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

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredList(
      position: widget.index,
      duration: const Duration(milliseconds: 450),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: Container(
            color: Colors.white,
            child: ExpansionTile(
              title: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
/*
                      ClipOval(
                        child: widget.memberData["Image"] != '' &&
                                widget.memberData["Image"] != null
                            ? FadeInImage.assetNetwork(
                                placeholder: '',
                                image: Image_Url +
                                    "${widget.memberData["Image"]}",
                                width: 50,
                                height: 50,
                                fit: BoxFit.fill)
                            : Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: cnst.appPrimaryMaterialColor,
                                ),
                                child: Center(
                                  child: Text(
                                    "${widget.memberData["Name"].toString().substring(0, 1).toUpperCase()}",
                                    style: TextStyle(
                                        fontSize: 25, color: Colors.white),
                                  ),
                                ),
                              ),
                      ),
*/
                      Expanded(
                        child: Padding(
                          padding:
                          const EdgeInsets.only(left: 8.0, bottom: 6.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("${widget.memberData["Name"]}",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[700])),
                              Row(
                                children: <Widget>[
                                  Text("Flat No:"),
                                  Text("${widget.memberData["FlatData"][0]["flatNo"]}")
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      IconButton(
                        icon: Image.asset("images/whatsapp_icon.png",
                            width: 30, height: 30),
                        onPressed: () {
                          _openWhatsapp(
                              widget.memberData["ContactNo"].toString());
                        },
                      ),
                      IconButton(
                          icon: Icon(Icons.call, color: Colors.brown),
                          onPressed: () {
                            launch("tel:" + widget.memberData["ContactNo"]);
                          }),
                      IconButton(
                          icon: Icon(Icons.remove_red_eye,
                              color: cnst.appPrimaryMaterialColor),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MemberProfile(
                                      memberData: widget.memberData,
                                    )));
                          }),
                      IconButton(
                          icon: Icon(Icons.share),
                          onPressed: () {
                            GetVcard();
                          }),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
