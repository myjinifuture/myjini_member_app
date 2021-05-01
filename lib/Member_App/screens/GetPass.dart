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

import '../common/constant.dart' as cnst;

class GetPass extends StatefulWidget {
  String Id = "";
  String mobileNo = "";
  GetPass({this.Id,this.mobileNo});
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
      // await Share.file('QR CODE IMAGE', 'esys.png', image, 'image/png',
      //     text: "${name}" + " is inviting you as a guest in their society\nPlease use this QrCode at the society gate");
      await launch('https://wa.me/+91${widget.mobileNo}?text=${name}+ is inviting you as a guest in their society\nPlease show this Code at the society gate ${widget.Id}');
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

  String name,wingName,flatNo;
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
      onWillPop: (){
        Navigator.pushReplacementNamed(context, "/MyGuestList");
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: RepaintBoundary(
          key: _containerKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView (
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "GATE PASS",
                      style: TextStyle(
                        fontSize: 24,
                        color: cnst.appPrimaryMaterialColor,
                        fontWeight: FontWeight.bold,
                      ),
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
                    backgroundColor: Colors.white,
                    data: widget.Id.toString(),
                    size: 0.3 * bodyHeight,
                    errorStateBuilder: (cxt, err) {
                      print("wrong");
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
                  Padding(
                    padding: const EdgeInsets.only(top:8.0),
                    child: Container(
                      child: Center(
                        child: Text(
                          '${widget.Id}'.split("-")[1],
                          textScaleFactor: 1.5,
                          style: TextStyle(color: Colors.black,
                          fontSize: 18,
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.black, spreadRadius: 1),
                        ],
                      ),
                      height: 48,
                      width: 140,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:20.0),
                    child: Container(
                      child: Column(
                        children: [
                        Text("${name}",
                        style: TextStyle(
                          color: Colors.purpleAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        ),
                        Text("${wingName}" + "-" + "${flatNo}",
                        style: TextStyle(
                          fontWeight: FontWeight.w200,
                          fontSize: 16,
                        ),
                        ),
                        Text("has invited you"),
                        ],
                      ),
                      height: 100,
                      width: 170,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:60.0),
                    child: Container(
                      child: Column(
                        children: [
                          Text("Please show this QR code",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                          Text("to the watchman at the gate",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                        ],
                      ),
                      width: MediaQuery.of(context).size.width*0.9,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: cnst.appPrimaryMaterialColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlineButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              highlightedBorderColor: Colors.white,
              borderSide: BorderSide(color: Colors.white, width: 1.5),
              onPressed: () {
                convertWidgetToImage();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.share_sharp,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Share",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
