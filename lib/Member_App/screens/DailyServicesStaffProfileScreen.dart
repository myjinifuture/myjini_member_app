import 'package:flutter/material.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:easy_gradient_text/easy_gradient_text.dart';
import 'dart:io';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Member_App/screens/StaffReviewListingScreen.dart';
import 'package:url_launcher/url_launcher.dart';

class DailyServicesStaffProfileScreen extends StatefulWidget {
  String categoryName;
  var staffProfileData;

  DailyServicesStaffProfileScreen({this.categoryName, this.staffProfileData});

  @override
  _DailyServicesStaffProfileScreenState createState() =>
      _DailyServicesStaffProfileScreenState();
}

class _DailyServicesStaffProfileScreenState
    extends State<DailyServicesStaffProfileScreen> {
  String wingId;
  String flatId;
  String societyId;
  bool alreadyInFlat = false;
  bool addToFlatCalled = false;
  bool removeFromFlatCalled = false;

  @override
  void initState() {
    setState(() {
      checkFlat();
    });
  }

  checkFlat() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    societyId = prefs.getString(constant.Session.SocietyId);
    wingId = prefs.getString(constant.Session.WingId);
    flatId = prefs.getString(constant.Session.FlatId);
    print("flatid in initstate");
    print(flatId);
    for (int i = 0; i < widget.staffProfileData["FlatData"].length; i++) {
      if (flatId == widget.staffProfileData["FlatData"][i]["_id"] &&
          wingId ==
              widget.staffProfileData["FlatData"][i]["WingData"][0]["_id"]) {
        setState(() {
          alreadyInFlat = true;
        });
      }
    }
  }

  removeFromFlat() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var data = {
          "societyId": societyId,
          "staffId": widget.staffProfileData["_id"],
          "wingId": wingId,
          "flatId": flatId,
        };
        Services.responseHandler(
                apiName: "member/removeMemberStaff", body: data)
            .then((data) async {
          if (data.Data.toString() == "1"&&data.IsSuccess==true) {
            print("data.Data");
            print(data.Data.runtimeType);
            print(data.Data);
            setState(() {
              Fluttertoast.showToast(
                  msg: "Removed from Flat Successfully",
                  backgroundColor: Colors.red,
                  gravity: ToastGravity.TOP,
                  textColor: Colors.white);
                Navigator.pop(context);

                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pushReplacementNamed(
                    context,
                    '/DailyServicesScreen');
              // removeFromFlatCalled = true;
            });
          } else {
            // showMsg("Complaint Is Not Added To Solved");
          }
        }, onError: (e) {
          showMsg("Something Went Wrong Please Try Again");
        });
      }
    } on SocketException catch (_) {
      showMsg("Something Went Wrong");
    }
  }

  addToFlat() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var data = {
          "staffId": widget.staffProfileData["_id"],
          "workLocation": [
            {
              "wingId": wingId,
              "flatId": flatId,
            },
          ]
        };
        Services.responseHandler(
                apiName: "member/addStaffWorkLocation", body: data)
            .then((data) async {
          if (data.Data.toString() == "1"&&data.IsSuccess==true) {
            setState(() {

              Fluttertoast.showToast(
                  msg: "Added to Flat Successfully",
                  backgroundColor: Colors.green,
                  gravity: ToastGravity.TOP,
                  textColor: Colors.white);
              setState(() {
                Navigator.pop(context);

                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pushReplacementNamed(
                    context,
                    '/DailyServicesScreen');
              });
            });
          } else {
            // showMsg("Complaint Is Not Added To Solved");
          }
        }, onError: (e) {
          showMsg("Something Went Wrong Please Try Again");
        });
      }
    } on SocketException catch (_) {
      showMsg("Something Went Wrong");
    }
  }

  showMsg(String msg, {String title = 'My JINI'}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(title),
          content: new Text(msg),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Okay"),
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
    print("widget.staffProfileData");
    print(widget.staffProfileData);
    return Stack(
      alignment: Alignment.center,
      children: [
        Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(130.0), // here the desired height
            child: AppBar(
              title: Text('${widget.categoryName} Profile'),
            ),
          ),

        ),
        Padding(
          padding: EdgeInsets.all(5.0),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.12,
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                ),
                child: Row(
                  children: [
                    widget.staffProfileData["staffImage"] == ""
                        ? Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ClipOval(
                              child: FadeInImage.assetNetwork(
                                  placeholder: 'images/user.png',
                                  image:
                                      "${constant.Image_Url}${widget.staffProfileData["staffImage"]}",
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.fill),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ClipOval(
                              child: Image.asset(
                                'images/user.png',
                                width: 100,
                                height: 100,
                              ),
                            ),
                          ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.staffProfileData["Name"].toUpperCase(),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            widget.staffProfileData["ContactNo1"],
                            style: TextStyle(
                              fontSize: 16,
                              // fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.call,
                                  color: constant.appPrimaryMaterialColor,
                                ),
                                onPressed: () {
                                  launch(
                                      "tel:${widget.staffProfileData["ContactNo1"]}");
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.share,
                                  color: constant.appPrimaryMaterialColor,
                                ),
                                onPressed: () {},
                              ),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              RatingBar.builder(
                                itemSize: 25,
                                initialRating: double.parse(widget
                                            .staffProfileData["TotalRatings"]
                                            .toString()) >=
                                        1.0
                                    ? double.parse(widget
                                        .staffProfileData["AverageRating"]
                                        .toString())
                                    : 0.0,
                                direction: Axis.horizontal,
                                itemCount: 5,
                                itemBuilder: (context, _) => Icon(
                                  Icons.star_rate_rounded,
                                  color: Colors.amber,
                                ),
                                ignoreGestures: true,
                                // onRatingUpdate: (rating) {
                                //   print(rating);
                                // },
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              widget.staffProfileData["AverageRating"] == null
                                  ? Text(
                                      '0.0',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        // color: Colors.grey,
                                      ),
                                    )
                                  : Text(
                                      '${widget.staffProfileData["AverageRating"].toString()}.0',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        // color: Colors.grey,
                                      ),
                                    ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5.0),
                            child: Text(
                              widget.staffProfileData["TotalRatings"] > 1
                                  ? '${widget.staffProfileData["TotalRatings"].toString()} Reviews'
                                  : '${widget.staffProfileData["TotalRatings"].toString()} Review',
                              style: TextStyle(
                                fontSize: 16,
                                // fontWeight: FontWeight.w600,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StaffReviewListingScreen(
                                ratingsData: widget.staffProfileData["Ratings"],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                                color: constant.appPrimaryMaterialColor,
                                width: 2),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GradientText(
                              text: "VIEW ALL",
                              colors: <Color>[
                                Color(0xffDA44bb),
                                Color(0xff8921aa)
                              ],
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.32,
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.home_rounded,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              widget.staffProfileData["NoOfWorkingFlats"] > 1
                                  ? 'WORKS IN ${widget.staffProfileData["NoOfWorkingFlats"].toString()} HOUSES'
                                  : 'WORKS IN ${widget.staffProfileData["NoOfWorkingFlats"].toString()} HOUSE',
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 5.0,
                            right: 5.0,
                          ),
                          child: GridView.builder(
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              // shrinkWrap: true,
                              padding: EdgeInsets.all(0),
                              itemCount:
                                  widget.staffProfileData["FlatData"].length,
                              gridDelegate:
                                  new SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: 1.5,
                                crossAxisCount: 4,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                return Chip(
                                  label: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 5.0,
                                      right: 5.0,
                                    ),
                                    child: Text(
                                        '${widget.staffProfileData["FlatData"][index]["WingData"][0]["wingName"]} - ${widget.staffProfileData["FlatData"][index]["flatNo"]}'),
                                  ),
                                );
                              }),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 10,
          child: alreadyInFlat == false
              ? RaisedButton(
                  color: constant.appPrimaryMaterialColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            title: Text(
                              "Confirm to add this Staff to your Flat ?",
                              textAlign: TextAlign.justify,
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      height: 40,
                                      width: 100,
                                      child: RaisedButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        color: constant.appPrimaryMaterialColor,
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          'No',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 40,
                                      width: 100,
                                      child: RaisedButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        color: constant.appPrimaryMaterialColor,
                                        onPressed: () {
                                          addToFlat();

                                        },
                                        child: Text(
                                          'Yes',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ));
                      },
                    );
                  },
                  child: Center(
                    child: Row(
                      children: [
                        Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        Text(
                          'Add to Flat',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : RaisedButton(
                  color: constant.appPrimaryMaterialColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            title: Text(
                              "Confirm to remove this Staff from your Flat ?",
                              textAlign: TextAlign.justify,
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      height: 40,
                                      width: 100,
                                      child: RaisedButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        color: constant.appPrimaryMaterialColor,
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          'No',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 40,
                                      width: 100,
                                      child: RaisedButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        color: constant.appPrimaryMaterialColor,
                                        onPressed: () {
                                          removeFromFlat();

                                        },
                                        child: Text(
                                          'Yes',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ));
                      },
                    );
                  },
                  child: Center(
                    child: Text(
                      'Remove from Flat',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
