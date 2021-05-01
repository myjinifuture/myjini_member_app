import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Admin_App/Screens/MemberProfile.dart';
import 'package:smart_society_new/Member_App/common/constant.dart';
import 'package:smart_society_new/Member_App/screens/fromMemberScreen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:smart_society_new/Admin_App/Common/Constants.dart' as cnst;
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';

class DirectoryMemberComponent extends StatefulWidget {
  var MemberData;

  int index;

  DirectoryMemberComponent(this.MemberData, this.index);

  @override
  _DirectoryMemberComponentState createState() =>
      _DirectoryMemberComponentState();
}

class _DirectoryMemberComponentState extends State<DirectoryMemberComponent> {
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

  @override
  void initState() {
    getLocalData();
  }

  String Member_Id;
  getLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      Member_Id = prefs.getString(Session.Member_Id);
    });
  }

  GetVcard() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });

        Services.GetVcardofMember(widget.MemberData['_id'].toString()).then(
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

  memberToMemberCalling(bool isVideoCall) async {
    try {
      print("tapped");
      final result = await InternetAddress.lookup('google.com');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

        var data = {
          "societyId" : prefs.getString(Session.SocietyId),
          "callerMemberId" : prefs.getString(Session.Member_Id),
          "callerWingId" : prefs.getString(Session.WingId),
          "callerFlatId" : prefs.getString(Session.FlatId),
          "receiverMemberId" : widget.MemberData["_id"].toString(),
          "receiverWingId" : widget.MemberData["WingData"][0]["_id"].toString(),
          "receiverFlatId" : widget.MemberData["FlatData"][0]["_id"].toString(),
          "contactNo" : widget.MemberData["ContactNo"].toString(),
          "AddedBy" : "Member",
          "isVideoCall" : isVideoCall,
          "callFor" : 0,
          "deviceType" : Platform.isAndroid ? "Android" : "IOS"
        };

        print("memberToMemberCalling Data = ${data}");
        Services.responseHandler(apiName: "member/memberCalling",body: data).then((data) async {
          if (data.Data.length > 0 && data.IsSuccess == true) {
            SharedPreferences preferences =
            await SharedPreferences.getInstance();
            // await preferences.setString('data', data.Data);
            // await for camera and mic permissions before pushing video page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FromMemberScreen(fromMemberData: widget.MemberData,isVideoCall:isVideoCall.toString()),
              ),
            );
            /*Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JoinPage(),
                    ),
                  );*/
          } else {

          }
        }, onError: (e) {
          showHHMsg("Try Again.","MyJini");
        });
      } else
        showHHMsg("No Internet Connection.","MyJini");
    } on SocketException catch (_) {
      showHHMsg("No Internet Connection.","MyJini");
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.MemberData);
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

                      ClipOval(
                        child: widget.MemberData["Image"] != '' &&
                                widget.MemberData["Image"] != null
                            ? FadeInImage.assetNetwork(
                                placeholder: '',
                                image: Image_Url +
                                    "${widget.MemberData["Image"]}",
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
                                    "${widget.MemberData["Name"].toString().substring(0, 1).toUpperCase()}",
                                    style: TextStyle(
                                        fontSize: 25, color: Colors.white),
                                  ),
                                ),
                              ),
                      ),

        Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 8.0, bottom: 6.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("${widget.MemberData["Name"]}".toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[700])),
                              Row(
                                children: <Widget>[
                                  // Text("${widget.MemberData["WingData"][0]["wingName"]}".toUpperCase()),
                                  // Text(" - "),
                                  Text("${widget.MemberData["FlatData"][0]["flatNo"]}".toUpperCase()),
                                ],
                              ),
                              widget.MemberData["Private"]["ContactNo"]
                              .toString() == "true" ?
                              Text("********"+"${widget.MemberData["ContactNo"]}".substring(8,10),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple
                              ),
                              ):
                              Text("${widget.MemberData["ContactNo"]}",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.purple
                                ),
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
                              widget.MemberData["ContactNo"].toString());
                        },
                      ),
                      // IconButton(
                      //     icon: Icon(Icons.call, color: Colors.brown),
                      //     onPressed: () {
                      //       launch("tel:" + widget.memberData["ContactNo"]);
                      //     }),
                      GestureDetector(
                        onTap: (){
                          if(Member_Id == widget.MemberData["_id"]){
                            Fluttertoast.showToast(
                              msg: "You cannot call to yourself",
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              gravity: ToastGravity.TOP,
                            );
                          }
                          else {
    // if(widget.MemberData["Private"]["ContactNo"]
    //     .toString() == "true"){
    // Fluttertoast.showToast(
    // msg: "Profile is Private",
    // backgroundColor: Colors.red,
    // textColor: Colors.white,
    // );
    // }
    // else {
      memberToMemberCalling(true);
    // }
                          }
                        },
                        child: Icon(
                          Icons.video_call,
                          color: Colors.red,
                          size: 31,
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
    if(Member_Id == widget.MemberData["_id"]){
    Fluttertoast.showToast(
    msg: "You cannot call to yourself",
    backgroundColor: Colors.red,
    textColor: Colors.white,
    gravity: ToastGravity.TOP,
    );
    }
    else {
      // if(widget.MemberData["Private"]["ContactNo"]
      //     .toString() == "true"){
      //   Fluttertoast.showToast(
      //     msg: "Profile is Private",
      //     backgroundColor: Colors.red,
      //     textColor: Colors.white,
      //   );
      // }
      // else{
        memberToMemberCalling(false);
      // }
    }
                        },
                        child: Icon(
                          Icons.call_end,
                          color: Colors.green,
                          size: 25,
                        ),
                      ),
                      IconButton(
                          icon: Icon(Icons.remove_red_eye,
                              color: cnst.appPrimaryMaterialColor),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MemberProfile(
                                          memberData: widget.MemberData,
                                      isContactNumberPrivate:widget.MemberData["Private"]["ContactNo"]
                                          .toString(),
                                        )));
                          }),
                      IconButton(
                          icon: Icon(Icons.share),
                          onPressed: () {
                            GetVcard(); // need to tell arpit sir to explain this to monil
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
