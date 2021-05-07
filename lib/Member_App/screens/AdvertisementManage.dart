import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;
import 'package:smart_society_new/Member_App/common/constant.dart';
import 'package:smart_society_new/Member_App/component/LoadingComponent.dart';
import 'package:smart_society_new/Member_App/screens/AdvertisementRenew.dart';

class AdvertisementManage extends StatefulWidget {
  @override
  _AdvertisementManageState createState() => _AdvertisementManageState();
}

class _AdvertisementManageState extends State<AdvertisementManage> {
  List _advertisementData = [];

  bool isLoading = false;

  ProgressDialog pr;

  @override
  void initState() {
    // getAdvertisementData();   told to monil to make this api
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(message: 'Please Wait');
  }

  getAdvertisementData() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.GetMyAdvertisement();
        setState(() {
          isLoading = true;
        });
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              _advertisementData = data;
              isLoading = false;
            });
          } else {
            setState(() {
              isLoading = false;
              _advertisementData = data;
            });
          }
        }, onError: (e) {
          showMsg("Something Went Wrong.\nPlease Try Again");
          setState(() {
            isLoading = false;
          });
        });
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  String setDate(String date) {
    String final_date = "";
    var tempDate;
    if (date != "" && date != null) {
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

  showLocations(List locationData, String type) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: <Widget>[
              Text(
                "$type List",
                style: TextStyle(
                    fontSize: 15,
                    color: constant.appPrimaryMaterialColor,
                    fontWeight: FontWeight.w600),
              ),
              Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 0.3)),
                child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: index % 2 == 0 ? Colors.grey[200] : Colors.white,
                      ),
                      height: 35,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "${locationData[index]["Name"]}",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800]),
                      ),
                    );
                  },
                  itemCount: locationData.length,
                ),
              ),
            ],
          ),
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

  void _showConfirmDialog(String Id, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("MYJINI"),
          content:
              new Text("Are You Sure You Want To Delete this Advertisement ?"),
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
                _deleteAdvertisement(Id, index);
              },
            ),
          ],
        );
      },
    );
  }

  _deleteAdvertisement(String id, int index) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // pr.show();
        Services.DeleteAdvertisement(id).then((data) async {
          if (data.Data == "1") {
            setState(() {
              _advertisementData.removeAt(index);
            });
            // pr.hide();
          } else {
            isLoading = false;
            showMsg("Something Went Wrong");
          }
        }, onError: (e) {
          showMsg("Something Went Wrong.\nPlease Try Again");
          // pr.hide();
        });
      } else {
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      // pr.hide();
      showMsg("Something Went Wrong");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Manage Promotions"),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(10),
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/HomeScreen', (route) => false);            },
          ),
        ),
        body: isLoading
            ? Container(
                child: Center(child: CircularProgressIndicator()),
              )
            : Column(
                children: <Widget>[
                  Expanded(
                    child: _advertisementData.length > 0
                        ? AnimationLimiter(
                            child: ListView.builder(
                              itemCount: _advertisementData.length,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                DateTime expiredDate = DateTime.parse(
                                    _advertisementData[index]["ExpiryDate"]);
                                return AnimationConfiguration.staggeredList(
                                  duration: const Duration(milliseconds: 375),
                                  child: SlideAnimation(
                                    verticalOffset: 100,
                                    child: Card(
                                      elevation: 3,
                                      margin: EdgeInsets.only(
                                          top: 7, left: 8, right: 8),
                                      child: Padding(
                                        padding: const EdgeInsets.all(7),
                                        child: Column(
                                          children: <Widget>[
                                            FadeInImage.assetNetwork(
                                              placeholder:
                                                  "images/placeholder.png",
                                              image: Image_Url +
                                                  '${_advertisementData[index]["Image"]}',
                                              height: 130,
                                              fit: BoxFit.fill,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: 7, left: 9),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Icon(
                                                        Icons.new_releases,
                                                        size: 15,
                                                        color: Colors.grey[600],
                                                      ),
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 4)),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Text(
                                                              "${_advertisementData[index]["Title"]}",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Colors
                                                                          .grey[
                                                                      700]),
                                                            ),
                                                            Text(
                                                              "Published On :${setDate(_advertisementData[index]["Date"])}",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .green),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      expiredDate.isAfter(
                                                              DateTime.now())
                                                          ? Row(
                                                              children: <
                                                                  Widget>[
                                                                Icon(
                                                                  Icons
                                                                      .done_all,
                                                                  size: 17,
                                                                  color: Colors
                                                                      .green,
                                                                ),
                                                                Padding(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                            left:
                                                                                3)),
                                                                Text(
                                                                  "Active",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      color: Colors
                                                                          .green),
                                                                ),
                                                              ],
                                                            )
                                                          : Text(
                                                              "Expired",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Colors
                                                                      .redAccent),
                                                            )
                                                    ],
                                                  ),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 5)),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 4),
                                                        child: Icon(
                                                          Icons.message,
                                                          size: 15,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 4)),
                                                      Expanded(
                                                        child: Text(
                                                          "${_advertisementData[index]["Description"]}",
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 18,
                                                                right: 10),
                                                        child: Text(
                                                          "Selected Package :${constant.Inr_Rupee}${double.parse(_advertisementData[index]["Price"].toString()).toStringAsFixed(0)}-${_advertisementData[index]["Duration"]}day",
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color: constant
                                                                  .appPrimaryMaterialColor),
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          showLocations(
                                                              _advertisementData[
                                                                      index][
                                                                  "TargetList"],
                                                              _advertisementData[
                                                                      index]
                                                                  ["Type"]);
                                                        },
                                                        child: Container(
                                                          child: Text(
                                                            "Locations",
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.grey,
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          4))),
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 3,
                                                                  bottom: 3,
                                                                  left: 6,
                                                                  right: 6),
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right: 6),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      expiredDate.isBefore(
                                                              DateTime.now())
                                                          ? Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  2.4,
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      top: 10),
                                                              child:
                                                                  MaterialButton(
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        new BorderRadius.circular(
                                                                            5.0)),
                                                                color: Colors
                                                                    .green,
                                                                onPressed: () {
                                                                  var data = {
                                                                    "title":
                                                                        "${_advertisementData[index]["Title"]}",
                                                                    "desc":
                                                                        "${_advertisementData[index]["Description"]}",
                                                                    "image": _advertisementData[
                                                                            index]
                                                                        [
                                                                        "Image"],
                                                                    "packageId":
                                                                        "${_advertisementData[index]["PackageId"]}",
                                                                    "type":
                                                                        "${_advertisementData[index]["Type"]}",
                                                                    "targetedId":
                                                                        "${_advertisementData[index]["TargetedId"]}",
                                                                  };
                                                                  Navigator
                                                                      .push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              AdvertisementRenew(
                                                                        data,
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: <
                                                                      Widget>[
                                                                    Icon(
                                                                      Icons
                                                                          .assignment_turned_in,
                                                                      size: 16,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                    Padding(
                                                                        padding:
                                                                            EdgeInsets.only(left: 3)),
                                                                    Text(
                                                                      "Renew",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontWeight:
                                                                              FontWeight.w600),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            )
                                                          : Container(),
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            2.4,
                                                        margin: EdgeInsets.only(
                                                            top: 10),
                                                        child: MaterialButton(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  new BorderRadius
                                                                          .circular(
                                                                      5.0)),
                                                          color: Colors.red,
                                                          onPressed: () {
                                                            _showConfirmDialog(
                                                                _advertisementData[
                                                                            index]
                                                                        ["Id"]
                                                                    .toString(),
                                                                index);
                                                          },
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Icon(
                                                                Icons.clear,
                                                                size: 16,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              3)),
                                                              Text(
                                                                "Delete",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : Container(
                            child: Center(child: Text("No Data Found")),
                          ),
                  ),
                  MaterialButton(
                      height: 45,
                      minWidth: MediaQuery.of(context).size.width,
                      color: constant.appprimarycolors[600],
                      onPressed: () {
                        Navigator.pushNamed(context, "/AdvertisementCreate");
                      },
                      child: Text(
                        "Promote",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      )),
                ],
              ),
      ),
    );
  }
}
