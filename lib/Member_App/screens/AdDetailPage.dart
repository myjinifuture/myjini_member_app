import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;
import 'package:smart_society_new/Member_App/screens/ViewProducts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as cnst;

class AdDetailPage extends StatefulWidget {
  var data;
  var index;

  AdDetailPage({this.data,this.index});

  @override
  _AdDetailPageState createState() => _AdDetailPageState();
}

class _AdDetailPageState extends State<AdDetailPage> {
  GoogleMapController mapController;
  final LatLng _center = const LatLng(21.203510, 72.839233);

  YoutubePlayerController _controller;
  String _playerStatus = '';

  bool _isPlayerReady = false;

  ProgressDialog pr;

  String memberid, qrData, advertisementid, WebURL, YoutubeURL;
  var Price;

  List WishList = [];
  bool isLoading = true;

  bool flag = false;
  bool wishliststatus;

  @override
  void initState() {
    _checkWishList();
    _getLocalData();
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
        message: "Please Wait..",
        borderRadius: 10.0,
        progressWidget: Container(
          padding: EdgeInsets.all(15),
          child: CircularProgressIndicator(
            //backgroundColor: cnst.appPrimaryMaterialColor,
          ),
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w600));
  }

  _checkWishList() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        String memberid = preferences.getString(cnst.Session.Member_Id);
        String advertisementid = widget.data["_id"].toString();
        Future res = Services.CheckWishList(memberid, advertisementid);
        setState(() {
          isLoading = true;
        });
        res.then((data) async {
          if (data == true) {
            setState(() {
              wishliststatus = data;
              isLoading = false;
            });
            print("Wishliststatus=> " + wishliststatus.toString());
          } else {
            setState(() {
              wishliststatus = false;
              isLoading = false;
            });
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          print("Error : on GetAd Data Call $e");
          showMsg("$e");
        });
      } else {
        showMsg("Something went Wrong!");
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  _wishListDelete() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var data = {
          "AdvertisementId": widget.data["_id"].toString(),
          "MemberId": prefs.getString(cnst.Session.Member_Id),
        };

        print("WishList Delete Data = ${data}");
        Services.WishListDelete(data).then((data) async {
          if (data.Data != "0" && data.IsSuccess == true) {
            _checkWishList();
            Fluttertoast.showToast(
                textColor: Colors.black,
                msg: "Removed From WishList",
                gravity: ToastGravity.TOP,
                toastLength: Toast.LENGTH_LONG);

            //Navigator.pop(context);
            /*  Navigator.pushNamedAndRemoveUntil(
                context, "/Dashboard", (Route<dynamic> route) => false);*/
          } else {
            showMsg(data.Message, title: "Error");
          }
        }, onError: (e) {
          showMsg("Try Again.");
        });
      } else
        showMsg("No Internet Connection.");
    } on SocketException catch (_) {
      // pr.hide();
      showMsg("No Internet Connection.");
    }
  }

  _addToWishList() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var data = {
          "Id": 0,
          "MemberId": prefs.getString(constant.Session.Member_Id),
          "AdvertisementId": widget.data["_id"],
        };

        print("AddToWishList Data = ${data}");
        Services.AddToWishList(data).then((data) async {
          if (data.Data != "0" && data.IsSuccess == true) {
            _checkWishList();
            Fluttertoast.showToast(
                msg: "Added to WishList",
                textColor: Colors.black,
                gravity: ToastGravity.TOP,
                toastLength: Toast.LENGTH_LONG);

            /*  Navigator.pushNamedAndRemoveUntil(
                context, "/Dashboard", (Route<dynamic> route) => false);*/
          } else {
            showMsg(data.Message, title: "Error");
          }
        }, onError: (e) {
          showMsg("Try Again.");
        });
      } else
        showMsg("No Internet Connection.");
    } on SocketException catch (_) {
      // pr.hide();
      showMsg("No Internet Connection.");
    }
  }

  /* _wishListUpdate() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var data = {
          "Id": WishList[0]["Id"],
        };
        print("Add Scanned Data = ${data}");
        Services.WishListUpdate(data).then((data) async {
          if (data.Data != "0" && data.IsSuccess == true) {
            setState(() {
              flag=false;
            });
            Fluttertoast.showToast(
                msg: "Added to WishList",
                textColor: Colors.black,
                gravity: ToastGravity.TOP,
                toastLength: Toast.LENGTH_LONG);
            */ /*  Navigator.pushNamedAndRemoveUntil(
                context, "/Dashboard", (Route<dynamic> route) => false);*/ /*
          } else {
            showMsg(data.Message, title: "Error");
          }
        }, onError: (e) {
          showMsg("Try Again.");
        });
      } else
        showMsg("No Internet Connection.");
    } on SocketException catch (_) {
      // pr.hide();
      showMsg("No Internet Connection.");
    }
  }*/

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

/*
  Future<void> share() async {
    await FlutterShare.share(
        title: 'Example share',
        text: 'Example share text',
        linkUrl: 'https://flutter.dev/',
        chooserTitle: 'Example Chooser Title'
    );
  }
*/

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
      final_date = "${tempDate[2].toString().substring(0, 2)}-"
          "${tempDate[1].toString().substring(0, 2)}-${tempDate[0].toString()}"
          .toString();
    }
    return final_date;
  }

  _launchURL(String toMailId, String subject, String body) async {
    var url = 'mailto:$toMailId?subject=$subject&body=$body';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchWebsiteURL() async {
    if (await canLaunch(WebURL)) {
      await launch(WebURL);
    } else {
      throw 'Could not launch $WebURL';
    }
  }

  _launchYoutubeURL() async {
    if (await canLaunch(YoutubeURL)) {
      await launch(YoutubeURL);
    } else {
      throw 'Could not launch $YoutubeURL';
    }
  }

  _openWhatsapp(mobile) {
    String whatsAppLink = constant.whatsAppLink;
    String urlwithmobile = whatsAppLink.replaceAll("#mobile", "91$mobile");
    String urlwithmsg = urlwithmobile.replaceAll("#msg", "");
    launch(urlwithmsg);
  }

  _getLocalData() async {
    print("Data--> " + widget.data.toString());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    WebURL = widget.data["WebsiteURL"];
    YoutubeURL = widget.data["VideoLink"];

    setState(() {
      memberid = prefs.getString(cnst.Session.Member_Id);
      advertisementid = widget.data["_id"].toString();
      Price = widget.data["Price"].toString();
    });

    setState(() {
      qrData = ((memberid != null ? memberid : '') +
          ',' +
          (advertisementid != null ? advertisementid : '') +
          ',' +
          (Price != null ? Price : ''));
    });
    print("qrdata--> " + qrData);
    //  print("Ad Id : " + widget.advertisementId);
    // print("Ad Price : " + widget.Price);
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void listener() {
    if (_isPlayerReady) {
      if (mounted && !_controller.value.isFullScreen) {
        setState(() {
          _playerStatus = _controller.value.playerState.toString();
        });
      }
    }
  }

  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  @override
  Widget build(BuildContext context) {
    print("widget.data");
    print(widget.data);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  FadeInImage.assetNetwork(
                      width: MediaQuery.of(context).size.width,
                      height: 220,
                      fit: BoxFit.fill,
                      placeholder: "images/Ad1.jpg",
                      image: "${cnst.Image_Url}" + widget.data["Image"][0].toString()),
                  Padding(
                    padding:
                    const EdgeInsets.only(left: 8.0, right: 8.0, top: 3.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/HomeScreen', (Route<dynamic> route) => false);
                          },
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        /* GestureDetector(
                          onTap: (){
                            setState(() {
                              flag=!flag;
                            });
                          },
                          child: flag==true?Icon(
                            Icons.bookmark,
                            size: 25,
                            color: Color(0xFF8B0000),
                          ):
                          Icon(
                            Icons.bookmark_border,
                            size: 25,
                            color: Colors.grey[400],
                          ),
                        ),*/
                        GestureDetector(
                          onTap: () {
                            Share.share('Check out this exclusive AD \n' +
                                "${cnst.Image_Url}" +
                                widget.data["Image"][0]);
                          },
                          child: Icon(
                            Icons.share,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Card(
                child: Column(
                  children: <Widget>[
                    /*Stack(
                      children: <Widget>[
                      */ /*  Container(
                          width: MediaQuery.of(context).size.width,
                          height: 250,
                          child: FadeInImage.assetNetwork(
                            width: MediaQuery.of(context).size.width,
                              height: 200,
                              placeholder: null,
                              image:
                                  'https://images.unsplash.com/photo-1517030330234-94c4fb948ebc?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1275&q=80'),
                          decoration: BoxDecoration(
                              */ /**/ /*image: DecorationImage(
                              image: NetworkImage(
                                  'https://images.unsplash.com/photo-1517030330234-94c4fb948ebc?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1275&q=80'),
                              fit: BoxFit.cover,
                            ),*/ /**/ /*
                              ),
                        ),*/ /*
                      ],
                    ),*/
                    /*   Image.asset(
                      "images/Ad1.jpg",
                      width: MediaQuery.of(context).size.width,
                      height: 250,
                    ),*/
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "${widget.data["Title"]}",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 18),
                              ),
                            )),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        // widget.data["Price"] == null ||
                        //         widget.data["Price"] == ""
                        //     ? Padding(
                        //         padding: const EdgeInsets.only(left: 8.0),
                        //         child: Text(
                        //           constant.Inr_Rupee + " 0.0",
                        //           style: TextStyle(
                        //               fontWeight: FontWeight.w500,
                        //               fontSize: 18,
                        //               color: Colors.green),
                        //         ),
                        //       )
                        //     : Padding(
                        //         padding: const EdgeInsets.only(left: 8.0),
                        //         child: Text(
                        //           constant.Inr_Rupee +
                        //               " ${widget.data["Price"]}",
                        //           style: TextStyle(
                        //               fontWeight: FontWeight.w500,
                        //               fontSize: 18,
                        //               color: Colors.green),
                        //         ),
                        //       ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              "${widget.data["Description"]}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                  color: Colors.green),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        // Expanded(
                        //   child: Padding(
                        //     padding: const EdgeInsets.only(left: 8.0),
                        //     child: Text(
                        //       "${widget.data["type"]}",
                        //       style: TextStyle(
                        //           fontWeight: FontWeight.w500, fontSize: 16),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
//                     Padding(
//                       padding: const EdgeInsets.only(top: 20.0),
//                       child: Row(
//                         children: <Widget>[
//                           Expanded(
//                             flex: 5,
//                             child: GestureDetector(
//                               onTap: () {
//                                 /*setState(() {
//                                   flag != flag;
//                                 });
//                                 _addToWishList();*/
//
//                                 if (wishliststatus != true) {
//                                   _addToWishList();
//                                 } else {
//                                   _wishListDelete();
//                                 }
//
// /*
//                                 if(WishList[0]["Status"]=="Added"){
//                                   _wishListUpdate();
//                                 }
//                                 else{
//                                   _addToWishList();
//
//                                 }*/
//                               },
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   border: Border.all(color: Colors.grey),
//                                 ),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: <Widget>[
//                                     wishliststatus == true
//                                         //flag == true
//                                         ? Icon(
//                                             Icons.bookmark,
//                                             size: 25,
//                                             color: Color(0xFF8B0000),
//                                           )
//                                         : Icon(
//                                             Icons.bookmark_border,
//                                             size: 25,
//                                             color: Colors.grey[400],
//                                           ),
//                                     Padding(
//                                       padding: EdgeInsets.only(left: 8.0),
//                                     ),
//                                     Text(
//                                       "Add to wishlist",
//                                       style: TextStyle(fontSize: 15),
//                                     )
//                                   ],
//                                 ),
//                                 height: 35,
//                               ),
//                             ),
//                           ),
//                           Expanded(
//                             flex: 5,
//                             child: GestureDetector(
//                               onTap: () {
//                                 /* String withappurl = withrefercode.replaceAll("#appurl", cnst.playstoreUrl);
//                                 Share.share(withappurl);*/
//                                 Share.share('Check out this exclusive AD \n' +
//                                     "${cnst.Image_Url}" +
//                                     widget.data["image"]);
//                               },
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   border: Border.all(),
//                                 ),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: <Widget>[
//                                     Icon(
//                                       Icons.share,
//                                       size: 25,
//                                       color: Colors.grey[400],
//                                     ),
//                                     Padding(
//                                       padding: EdgeInsets.only(left: 8.0),
//                                     ),
//                                     Text(
//                                       "Share this deal",
//                                       style: TextStyle(fontSize: 15),
//                                     )
//                                   ],
//                                 ),
//                                 height: 35,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
                  ],
                ),
              ),
              // Card(
              //   child: ExpansionTile(
              //     title: Text(
              //       "Redeem Bill Date",
              //       style: TextStyle(
              //           fontSize: 18,
              //           fontWeight: FontWeight.w500,
              //           color: Colors.black),
              //     ),
              //     children: <Widget>[
              //       Padding(
              //         padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.start,
              //           children: <Widget>[
              //             //here
              //             Text(
              //               "Expiry Date - ${setDate(widget.data["ExpiryDate"])}",
              //               style: TextStyle(
              //                 fontSize: 15,
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              Card(
                child: ExpansionTile(
                  title: Text(
                    "Location",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              widget.data["AdvertiserAddress"] == null ||
                                  widget.data["AdvertiserAddress"] == ""
                                  ? Text(
                                " ",
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              )
                                  : Expanded(
                                child: Text(
                                  "${widget.data["AdvertiserAddress"]}",
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: GestureDetector(
                              onTap: () {
                                // if (widget.data["AdvertiserLocation"] == "" ||
                                //     widget.data["AdvertiserLocation"] == null) {
                                //   Fluttertoast.showToast(
                                //       msg: "Location not available!!!",
                                //       toastLength: Toast.LENGTH_SHORT);
                                // } else {
                                //   var latlong = widget
                                //       .data["AdvertiserLocation"]
                                //       .toString()
                                //       .split(",");
                                //   openMap(double.parse(latlong[0]),
                                //       double.parse(latlong[1]));
                                // }
                                // print("LAT-LONG == >>>" +
                                //     widget.data["AdvertiserLocation"]
                                //         .toString());
                                launch(
                                    '${widget.data["GoogleMap"]}');
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width / 1.3,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.blue),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                      const EdgeInsets.only(left: 15.0),
                                      child: Icon(
                                        Icons.location_on,
                                        size: 25,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 8.0),
                                    ),
                                    Text(
                                      "Get direction",
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.blue),
                                    )
                                  ],
                                ),
                                height: 35,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          if (widget.data["EmailId"] == "" ||
                              widget.data["EmailId"] == null) {
                            Fluttertoast.showToast(
                                msg: "Email not available!!!",
                                toastLength: Toast.LENGTH_SHORT);
                          } else {
                            _launchURL(
                                '${widget.data["EmailId"]}', '', '');
                          }
                          print("EmailId--> " + widget.data["EmailId"]);
                        },
                        child: Image.asset(
                          "images/gmail.png",
                          height: 32,
                          width: 32,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (widget.data["WebsiteURL"] == "" ||
                              widget.data["WebsiteURL"] == null) {
                            Fluttertoast.showToast(
                                msg: "Website Link not available!!!",
                                toastLength: Toast.LENGTH_SHORT);
                          } else {
                            _launchWebsiteURL();
                          }
                          print("WebsiteURL--> " + widget.data["WebsiteURL"]);
                        },
                        child: Image.asset(
                          "images/website.png",
                          color: Colors.blue,
                          height: 32,
                          width: 32,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (widget.data["VideoLink"] == "" ||
                              widget.data["VideoLink"] == null) {
                            Fluttertoast.showToast(
                                msg: "Youtube Link not available!!!",
                                toastLength: Toast.LENGTH_SHORT);
                          } else {
                            _launchYoutubeURL();
                          }
                          print("VideoLink--> " + widget.data["VideoLink"]);
                        },
                        child: Image.asset(
                          "images/youtube.png",
                          height: 32,
                          width: 32,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (widget.data["ContactNo"] == "" ||
                              widget.data["ContactNo"] == null) {
                            Fluttertoast.showToast(
                                msg: "Mobile Number not available!!!",
                                toastLength: Toast.LENGTH_SHORT);
                          } else {
                            launch('tel:${widget.data["ContactNo"]}');
                          }
                          print("VideoLink--> " +
                              widget.data["ContactNo"]);
                        },
                        child: Image.asset(
                          "images/telephone.png",
                          height: 32,
                          width: 32,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 10.0, left: 10, right: 10, bottom: 10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 35,
                        child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            color: constant.appPrimaryMaterialColor,
                            textColor: Colors.white,
                            splashColor: Colors.white,
                            child: Text("Get Offer",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600)),
                            onPressed: () {
                              _settingModalBottomSheet(context, qrData);
                            }),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 5),
                    ),
                    Expanded(
                      flex: 5,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 35,
                        child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            color: constant.appPrimaryMaterialColor,
                            textColor: Colors.white,
                            splashColor: Colors.white,
                            child: Text("Services",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600)),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ViewProducts(widget.data)));
                            }),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _settingModalBottomSheet(context, String qr) {
  showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(10.0),
              topRight: const Radius.circular(10.0))),
      context: context,
      builder: (BuildContext bc) {
        return Container(
          child: new Wrap(
            children: <Widget>[
              Center(
                child: QrImage(
                  data: "${qr}",
                  version: QrVersions.auto,
                  size: 150.0,
                ),
              ),
              Center(
                  child: Text(
                    "Scan QR",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  )),
            ],
          ),
        );
      });
}