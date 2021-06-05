import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;
import 'package:smart_society_new/Member_App/common/constant.dart';
import 'package:smart_society_new/Member_App/screens/MemberProfile.dart';
import 'package:smart_society_new/Member_App/screens/fromMemberScreen.dart';
import 'package:url_launcher/url_launcher.dart';

class GlobalMemberComponent extends StatefulWidget {
  var MemberData;

  GlobalMemberComponent(this.MemberData);

  @override
  _GlobalMemberComponentState createState() => _GlobalMemberComponentState();
}

_openWhatsapp(mobile) {
  String whatsAppLink = constant.whatsAppLink;
  String urlwithmobile = whatsAppLink.replaceAll("#mobile", "91$mobile");
  String urlwithmsg = urlwithmobile.replaceAll("#msg", "");
  launch(urlwithmsg);
}

class _GlobalMemberComponentState extends State<GlobalMemberComponent> {
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

  callingToMemberFromWatchmen(String CallingType) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        FormData formData = new FormData.fromMap({
          "FromName": prefs.getString(Session.Name),
          "SocietyId": prefs.getString(Session.SocietyId),
          "ContactNo": widget.MemberData["ContactNo"].toString(),
          "ToCallId": widget.MemberData["Id"].toString(),
          "ToName": widget.MemberData["Name"].toString(),
          "WingId": widget.MemberData["WingId"].toString(),
          "FlatId": widget.MemberData["FlatNo"].toString(),
          "AddedBy": "Member",
          // "WatchManId": prefs.getString(Session.MemberId),
          "CallingType": CallingType
        });

        print("callingToMemberFromWatchmen Data = ${formData.fields}");
        // Services.callingToMemberFromWatchmen(formData).then((data) async {
        //   print("data12345");
        //   print(data.Data);
        //
        //   if (data.Data != "0" && data.IsSuccess == true) {
        //     SharedPreferences preferences =
        //     await SharedPreferences.getInstance();
        //     await preferences.setString('data', data.Data);
        //     // await for camera and mic permissions before pushing video page
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) => FromMemberScreen(fromMemberData: widget.MemberData,CallingType:CallingType),
        //       ),
        //     );
        //     /*Navigator.push(
        //             context,
        //             MaterialPageRoute(
        //               builder: (context) => JoinPage(),
        //             ),
        //           );*/
        //   } else {
        //
        //   }
        // }, onError: (e) {
        //   showHHMsg("Try Again.","MyJini");
        // });
      } else
        showHHMsg("No Internet Connection.", "MyJini");
    } on SocketException catch (_) {
      showHHMsg("No Internet Connection.", "MyJini");
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.MemberData);
    return ExpansionTile(
      title: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 1.0, top: 2, bottom: 1),
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    image: new DecorationImage(
                        image: widget.MemberData["Image"] == null ||
                                widget.MemberData["Image"] == ""
                            ? AssetImage("images/man.png")
                            : NetworkImage(constant.Image_Url +
                                '${widget.MemberData["Image"]}'),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.all(new Radius.circular(75.0)),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, bottom: 6.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("${widget.MemberData["Name"]}",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700])),
                      Text(
                        "${widget.MemberData["WingData"][0]["wingName"]}-${widget.MemberData["FlatData"][0]["flatNo"]}",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                      widget.MemberData["IsPrivate"] == false ||
                              widget.MemberData["IsPrivate"] == null
                          ? Text('${widget.MemberData["ContactNo"]}')
                          : Text('${widget.MemberData["ContactNo"]}'
                              .replaceRange(0, 6, "******")),
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
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("${widget.MemberData["Designation"]}",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700])),
                  // Row(
                  //   children: <Widget>[
                  //     Icon(
                  //       Icons.business_center,
                  //       color: Colors.grey[400],
                  //       size: 15,
                  //     ),
                  //     Text(
                  //       "Business",
                  //       style: TextStyle(
                  //           fontSize: 11,
                  //           fontStyle: FontStyle.italic,
                  //           color: Colors.grey[400]),
                  //     ),
                  //   ],
                  // )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // widget.MemberData["vehicle"].length > 0
                  //     ? Column(
                  //         children: <Widget>[
                  //           Text(
                  //               "${widget.MemberData["vehicle"][0]["VehicleNo"]}",
                  //               style: TextStyle(
                  //                   fontSize: 14,
                  //                   fontWeight: FontWeight.w600,
                  //                   color: Colors.grey[700]))
                  //         ],
                  //       )
                  //     : Container(
                  //         child: Text("No Vehicle Added"),
                  //       ),
                  // Row(
                  //   children: <Widget>[
                  //     Icon(
                  //       Icons.directions_bike,
                  //       color: Colors.grey[400],
                  //       size: 15,
                  //     ),
                  //     Text(
                  //       "Vehicle",
                  //       style: TextStyle(
                  //           fontSize: 11,
                  //           fontStyle: FontStyle.italic,
                  //           color: Colors.grey[400]),
                  //     ),
                  //   ],
                  // )
                ],
              ),
            ],
          ),
        ),
/*
        Container(
          width: MediaQuery.of(context).size.width - 10,
          decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.all(Radius.circular(3.0))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  */
/*!widget.MemberData["IsPrivate"] == true
                              ? Fluttertoast.showToast(
                            msg: "Profile is Private",
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                          )
                              :*//*

// launch("tel:${widget.MemberData["ContactNo"]}");
                  callingToMemberFromWatchmen("VideoCalling");
                },
                child: Icon(
                  Icons.video_call,
                  color: Colors.red,
                  size: 31,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              GestureDetector(
                onTap: () {
                  */
/*!widget.MemberData["IsPrivate"] == true
                              ? Fluttertoast.showToast(
                            msg: "Profile is Private",
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                          )
                              :*//*

// launch("tel:${widget.MemberData["ContactNo"]}");
                  callingToMemberFromWatchmen("VoiceCall");
                },
                child: Icon(
                  Icons.call_end,
                  color: Colors.green,
                  size: 31,
                ),
              ),
            ],
          ),
        )
*/
      ],
    );
  }
}
