import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Member_App/common/constant.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:dotted_border/dotted_border.dart';
import '../common/constant.dart' as cnst;

class GetPass extends StatefulWidget {
  String Id = "";
  String mobileNo = "";

  GetPass({this.Id, this.mobileNo});

  @override
  _GetPassState createState() => _GetPassState();
}

class _GetPassState extends State<GetPass> {
      GlobalKey _containerKey = GlobalKey();

  void convertWidgetToImage() async {
    RenderRepaintBoundary renderRepaintBoundary =
        _containerKey.currentContext.findRenderObject();
    ui.Image boxImage = await renderRepaintBoundary.toImage(pixelRatio: 5);
    ByteData byteData =
        await boxImage.toByteData(format: ui.ImageByteFormat.png);
    Uint8List uInt8List = byteData.buffer.asUint8List();
    _shareImage(uInt8List);
  }

  Future<void> _shareImage(Uint8List image) async {
    try {
      await Share.file('esys image', 'esys.png', image, 'image/png',
          text: "Gate Pass, This Gate Pass is valid only 1 time");
    } catch (e) {
      print('error: $e');
    }
  }

  String _inputErrorText;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("id");
    print(widget.Id);
    getLocalData();
  }

  String name, wingName, flatNo;

  getLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      wingName = prefs.getString(Session.Wing);
      flatNo = prefs.getString(Session.FlatNo);
      name = prefs.getString(Session.Name);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bodyHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).viewInsets.bottom;
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacementNamed(context, "/MyGuestList");
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        // body: RepaintBoundary(
        //   key: _containerKey,
        //   child: Padding(
        //     padding: const EdgeInsets.all(20.0),
        //     child: SingleChildScrollView (
        //       child: Column(
        //         children: [
        //           Padding(
        //             padding: const EdgeInsets.all(8.0),
        //             child: Text(
        //               "GATE PASS",
        //               style: TextStyle(
        //                 fontSize: 24,
        //                 color: cnst.appPrimaryMaterialColor,
        //                 fontWeight: FontWeight.bold,
        //               ),
        //             ),
        //           ),
        //           Container(
        //             width: MediaQuery.of(context).size.width,
        //             height: 1,
        //             color: Colors.grey[200],
        //           ),
        //           SizedBox(
        //             height: 10,
        //           ),
        //           QrImage(
        //             backgroundColor: Colors.white,
        //             data: widget.Id.toString(),
        //             size: 0.3 * bodyHeight,
        //             errorStateBuilder: (cxt, err) {
        //               print("wrong");
        //               return Container(
        //                 child: Center(
        //                   child: Text(
        //                     "Uh oh! Something went wrong...",
        //                     textAlign: TextAlign.center,
        //                   ),
        //                 ),
        //               );
        //             },
        //           ),
        //           Padding(
        //             padding: const EdgeInsets.only(top:8.0),
        //             child: Container(
        //               child: Center(
        //                 child: Text(
        //                   '${widget.Id}'.split("-")[1],
        //                   textScaleFactor: 1.5,
        //                   style: TextStyle(color: Colors.black,
        //                   fontSize: 18,
        //                   ),
        //                 ),
        //               ),
        //               decoration: BoxDecoration(
        //                 borderRadius: BorderRadius.circular(10),
        //                 color: Colors.white,
        //                 boxShadow: [
        //                   BoxShadow(color: Colors.black, spreadRadius: 1),
        //                 ],
        //               ),
        //               height: 48,
        //               width: 140,
        //             ),
        //           ),
        //           Padding(
        //             padding: const EdgeInsets.only(top:20.0),
        //             child: Container(
        //               child: Column(
        //                 children: [
        //                 Text("${name}",
        //                 style: TextStyle(
        //                   color: Colors.purpleAccent,
        //                   fontWeight: FontWeight.bold,
        //                   fontSize: 20,
        //                 ),
        //                 ),
        //                 Text("${wingName}" + "-" + "${flatNo}",
        //                 style: TextStyle(
        //                   fontWeight: FontWeight.w200,
        //                   fontSize: 16,
        //                 ),
        //                 ),
        //                 Text("has invited you"),
        //                 ],
        //               ),
        //               height: 100,
        //               width: 170,
        //               decoration: BoxDecoration(
        //                 borderRadius: BorderRadius.circular(10),
        //                 color: Colors.white,
        //               ),
        //             ),
        //           ),
        //           Padding(
        //             padding: const EdgeInsets.only(top:40.0),
        //             child: Container(
        //               child: Column(
        //                 children: [
        //                   Text("Please show this QR code to the Watchman at the Gate",textAlign: TextAlign.justify,
        //                     style: TextStyle(
        //                       color: Colors.green,
        //                       fontWeight: FontWeight.bold,
        //                       fontSize: 25,
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //               width: MediaQuery.of(context).size.width*0.9,
        //               decoration: BoxDecoration(
        //                 borderRadius: BorderRadius.circular(10),
        //                 color: Colors.white,
        //               ),
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
        body: RepaintBoundary(
            key: _containerKey,
          child: Container(
            color: Colors.grey[400],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: FlutterTicketWidget(
                    isCornerRounded: true,
                    width: MediaQuery.of(context).size.width,
                    height: Platform.isAndroid ? 450 : 500,
                    child: Column(
                      children: [
                        Container(
                          child: Column(
                            children: [
                              Platform.isIOS ? IconButton(
                                  icon: Icon(Icons.clear),
                                  iconSize: 20,
                                  color: Colors.grey[400],
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  }):Container(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "GATE PASS",
                                  style: TextStyle(
                                      fontSize: 24,
                                      color: appPrimaryMaterialColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 1,
                                color: Colors.grey[200],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              QrImage(
                                data: widget.Id.toString(),
                                version: 1,
                                size: 150,
                                gapless: false,
                                errorStateBuilder: (cxt, err) {
                                  return Container(
                                    child: Center(
                                      child: Text(
                                        "Uh oh! Something went wrong...",
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              DottedBorder(
                                  dashPattern: [4],
                                  padding: EdgeInsets.all(6.0),
                                  child: Text(
                                    '${widget.Id}'.split("-")[1],
                                    style: TextStyle(
                                        fontSize: 30,
                                        color: appPrimaryMaterialColor,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 3),
                                  )),
                              SizedBox(
                                height: 10,
                              ),
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  text: name,
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: appPrimaryMaterialColor,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat'),
                                  children: [],
                                ),
                              ),
                              Text('has invited you',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.normal,
                                      fontFamily: 'Montserrat')),

                              Divider(
                                endIndent: 10,
                                indent: 10,
                              ),
                            ],
                          ),
                        ),
                        Center(
                          child: Container(height: 50,width: 50,
                            child: Image.asset('images/Logo.png'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: "Please show this",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  fontFamily: 'Montserrat'),
                              children: [
                                TextSpan(
                                    text: " QR Code ",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                  text:
                                      "to Security Guard at the Society Gate for hassle free entry",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Expanded(
                        //   child: Container(
                        //     child: Column(
                        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //       children: [
                        //         Row(
                        //           mainAxisAlignment:
                        //           MainAxisAlignment.spaceAround,
                        //           children: [
                        //             Column(
                        //               crossAxisAlignment:
                        //               CrossAxisAlignment.center,
                        //               children: [
                        //                 Text("Valid From",
                        //                     style: fontConstants.labelFonts),
                        //                 Text(
                        //                   "${widget.myGuestData["validFrom"]}",
                        //                   style: fontConstants.valueFonts,
                        //                 ),
                        //                 Text(
                        //                   "12 AM",
                        //                   style: fontConstants.activeFonts,
                        //                 ),
                        //               ],
                        //             ),
                        //             Column(
                        //               crossAxisAlignment:
                        //               CrossAxisAlignment.center,
                        //               children: [
                        //                 Text("Valid to",
                        //                     style: fontConstants.labelFonts),
                        //                 Text(
                        //                   "${widget.myGuestData["validTo"]}",
                        //                   style: fontConstants.valueFonts,
                        //                 ),
                        //                 Text(
                        //                   "12 AM",
                        //                   style: fontConstants.activeFonts,
                        //                 ),
                        //               ],
                        //             )
                        //           ],
                        //         ),
                        //         Image.asset(
                        //           "images/Watcherlogo.png",
                        //           width: 60,
                        //         ),
                        //         Padding(
                        //           padding: const EdgeInsets.all(8.0),
                        //           child: RichText(
                        //             textAlign: TextAlign.center,
                        //             text: TextSpan(
                        //               text: "Please show this",
                        //               style: TextStyle(
                        //                   fontSize: 12,
                        //                   color: Colors.grey,
                        //                   fontFamily: 'Montserrat'),
                        //               children: [
                        //                 TextSpan(
                        //                     text: " QR Code ",
                        //                     style: TextStyle(
                        //                         fontSize: 12,
                        //                         color: Colors.black,
                        //                         fontWeight: FontWeight.bold)),
                        //                 TextSpan(
                        //                   text:
                        //                   "to Security Guard at the Society Gate for hassle free entry",
                        //                   style: TextStyle(
                        //                       fontSize: 12,
                        //                       color: Colors.grey,
                        //                       fontWeight: FontWeight.normal),
                        //                 ),
                        //               ],
                        //             ),
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Container(
          height: 45,
          width: MediaQuery.of(context).size.width - 100,
          child: RaisedButton(
            color: cnst.appPrimaryMaterialColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            onPressed: () {
              convertWidgetToImage();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.share,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  'Share',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ),
        // bottomNavigationBar: Container(
        //   width: MediaQuery.of(context).size.width-40,
        //   child:
        // )),
      ),
    );
  }
}

class FlutterTicketWidget extends StatefulWidget {
  final double width;
  final double height;
  final Widget child;
  final Color color;
  final bool isCornerRounded;

  FlutterTicketWidget(
      {@required this.width,
      @required this.height,
      @required this.child,
      this.color = Colors.white,
      this.isCornerRounded = false});

  @override
  _FlutterTicketWidgetState createState() => _FlutterTicketWidgetState();
}

class _FlutterTicketWidgetState extends State<FlutterTicketWidget> {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: TicketClipper(),
      child: AnimatedContainer(
        duration: Duration(seconds: 3),
        width: widget.width,
        height: widget.height,
        child: widget.child,
        decoration: BoxDecoration(
            color: widget.color,
            borderRadius: widget.isCornerRounded
                ? BorderRadius.circular(12.0)
                : BorderRadius.circular(0.0)),
      ),
    );
  }
}

class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);

    path.addOval(
        Rect.fromCircle(center: Offset(0.0, size.height / 1.5), radius: 20.0));
    path.addOval(Rect.fromCircle(
        center: Offset(size.width, size.height / 1.5), radius: 20.0));

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
