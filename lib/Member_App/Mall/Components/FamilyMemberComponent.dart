import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:smart_society_new/Mall_App/Common/Colors.dart';
import 'package:smart_society_new/Mall_App/transitions/slide_route.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/screens/CustomerProfile.dart';
import 'package:smart_society_new/Member_App/screens/updateMemberdetailform.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FamilyMemberComponent extends StatefulWidget {
  var familyData, memberName,residenceTypeOfParentMember;
  Function onDelete, onUpdate;

  FamilyMemberComponent(
      {this.familyData, this.onDelete, this.onUpdate, this.memberName,this.residenceTypeOfParentMember});

  @override
  _FamilyMemberComponentState createState() => _FamilyMemberComponentState();
}

class _FamilyMemberComponentState extends State<FamilyMemberComponent> {
  bool isLoading = false;
  String relation = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.residenceTypeOfParentMember != widget.familyData["society"]["ResidenceType"].toString()){
      relation = "On Rent";
    }
  }

  @override
  Widget build(BuildContext context) {
    print("widget.familyData");
    print(widget.familyData);
    return GestureDetector(
      onTap: () {
        _settingModalBottomSheet();
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 8, left: 8),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          widget.familyData['Image'] == ''
                              ? Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(100.0))),
                                  width: 80,
                                  height: 80,
                                  child: Padding(
                                    padding: const EdgeInsets.all(25.0),
                                    child: Image.asset("images/family.png",
                                        width: 40, color: Colors.grey[400]),
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: FadeInImage.assetNetwork(
                                      placeholder: '',
                                      image: constant.Image_Url +
                                          "${widget.familyData['Image']}",
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.fill),
                                ),
                          Text(
                            "${widget.familyData["Name"]}",
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                          relation == "" ? Text(
                            "${widget.familyData["Relation"]}",
                            style: TextStyle(
                              fontSize: 12,
                              color: appPrimaryMaterialColor,
                            ),
                          ):Text(
                            relation,
                            style: TextStyle(
                              fontSize: 12,
                              color: appPrimaryMaterialColor,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          launch(('tel:// ${widget.familyData["ContactNo"]}'));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.call_sharp,
                            size: 20,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15),
                        child: Container(
                          color: Colors.grey,
                          width: 1,
                          height: 25,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Share.share(
                              "Hello, My Name is ${widget.memberName}\nI have added you as a Family Member\nYou can Login from the application link below:\nhttp://tinyurl.com/wz2aeao\nMYJINI MANAGEMENT PVT LTD\nDownload MyJini App now to manage your society security, maintenance, staffing\nwww.myjini.in");
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.share,
                            size: 20,
                            color: Colors.black54,
                          ),
                        ),
                      ),
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

  //family detail bottom sheet

  void _showConfirmDialog(
      {String memberId, String societyId, String wingId, String flatId}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDelete(
          deleteId: memberId,
          flatId: flatId,
          societyId: societyId,
          wingId: wingId,
          onDelete: widget.onDelete,
        );
      },
    );
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
                ;
              },
            ),
          ],
        );
      },
    );
  }

  void _settingModalBottomSheet() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.0),
        ),
        backgroundColor: Colors.white,
        context: context,
        builder: (builder) {
          return new Container(
              height: 240.0,
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Text(
                        "Family",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w600
                            //fontWeight: FontWeight.bold
                            ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20.0, right: 15, left: 25, bottom: 15),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/assets/profile.png'),
                            backgroundColor: appPrimaryMaterialColor,
                            radius: 45,
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${widget.familyData["Name"]}",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    "${widget.familyData["Relation"]}",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: appPrimaryMaterialColor,
                                    ),
                                  ),
                                  Text(
                                    "${widget.familyData["ContactNo"]}",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      SlideLeftRoute(
                                          page: updateFamilyMemberForm(
                                        FmemberData: widget.familyData,
                                        onUpdate: () {
                                          setState(() {
                                            widget.onUpdate();
                                          });
                                        },
                                      )));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Icon(Icons.edit),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  _showConfirmDialog(
                                      memberId: widget.familyData["_id"],
                                      societyId: widget.familyData["society"][0]
                                          ["societyId"],
                                      wingId: widget.familyData["society"][0]
                                          ["wingId"],
                                      flatId: widget.familyData["society"][0]
                                          ["flatId"]);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Icon(Icons.delete),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 60,
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: Container(
                              color: appPrimaryMaterialColor,
                              width: MediaQuery.of(context).size.width / 2.01,
                              child: FlatButton(
                                  onPressed: () {
                                    launch(
                                        ('tel:// ${widget.familyData["ContactNo"]}'));
                                  },
                                  child: Center(
                                    child: Text(
                                      "Call Now",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 0.0, top: 2),
                            child: Container(
                              color: appPrimaryMaterialColor,
                              width: MediaQuery.of(context).size.width / 2,
                              child: FlatButton(
                                  onPressed: () {
                                    Share.share(
                                        "Hello, My Name is ${widget.memberName}\nI have added you as a Family Member\nYou can Login from the application link below:\nhttp://tinyurl.com/wz2aeao\nMYJINI MANAGEMENT PVT LTD\nDownload MyJini App now to manage your society security, maintenance, staffing\nwww.myjini.in");
                                  },
                                  child: Center(
                                    child: Text(
                                      "Invite to MyJini",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ));
        });
  }
}

class AlertDelete extends StatefulWidget {
  var deleteId;
  var societyId;
  var wingId;
  var flatId;
  Function onDelete;

  AlertDelete(
      {this.deleteId, this.onDelete, this.societyId, this.flatId, this.wingId});

  @override
  _AlertDeleteState createState() => _AlertDeleteState();
}

class _AlertDeleteState extends State<AlertDelete> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: new Text("MYJINI"),
      content: new Text("Are You Sure You Want To Delete this Member ?"),
      actions: <Widget>[
        new FlatButton(
          child: new Text("No",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        new FlatButton(
          child: new Text("Yes",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
          onPressed: () {
            Navigator.pop(context);
            deleteFamilyMember();
          },
        ),
      ],
    );
  }

  // _DeleteFamilyMember(String Id) async {
  //   try {
  //     final result = await InternetAddress.lookup('google.com');
  //     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
  //       // setState(() {
  //       //   isLoading = true;
  //       // });
  //       Services.DeleteFamilyMember(Id).then((data) async {
  //         if (data.Data == "1") {
  //           // setState(() {
  //           //   isLoading = false;
  //           // });
  //
  //           // Navigator.pushReplacement(
  //           //     context, SlideLeftRoute(page: CustomerProfile()));
  //           widget.onDelete();
  //         } else {
  //           // isLoading = false;
  //           showHHMsg("Member Is Not Deleted", "");
  //         }
  //       }, onError: (e) {
  //         //isLoading = false;
  //         showHHMsg("$e", "");
  //         //isLoading = false;
  //       });
  //     } else {
  //       showHHMsg("No Internet Connection.", "");
  //     }
  //   } on SocketException catch (_) {
  //     showHHMsg("Something Went Wrong", "");
  //   }
  // }

  deleteFamilyMember() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

        var data = {
          "memberId": widget.deleteId,
          "societyId": widget.societyId,
          "wingId": widget.wingId,
          "flatId": widget.flatId,
        };
        Services.responseHandler(
                apiName: "member/removeFromProperty", body: data)
            .then((data) async {
          if (data.Data.toString() == '1' ) {

              Fluttertoast.showToast(
                  msg: "Family member deleted Successfully!!!",
                  backgroundColor: Colors.red,
                  gravity: ToastGravity.TOP,
                  textColor: Colors.white);
              widget.onDelete();
          } else {

          }
        }, onError: (e) {

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
                ;
              },
            ),
          ],
        );
      },
    );
  }
}
