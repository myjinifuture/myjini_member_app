import 'package:flutter/material.dart';
import 'package:smart_society_new/Member_App/common/constant.dart';
import 'package:smart_society_new/Member_App/screens/AdDetailPage.dart';

class BannerScreen extends StatefulWidget {
  var bannerData;
  BannerScreen({this.bannerData});
  @override
  _BannerScreenState createState() => _BannerScreenState();
}

class _BannerScreenState extends State<BannerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView.builder(
          itemCount: widget.bannerData.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdDetailPage(
                      data: widget.bannerData[index],
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10, top: 5),
                child: new Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height*0.35,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(0.0)),
                    ),
                    child: Image.network(
                        Image_Url + widget.bannerData[index]["Image"][0],
                        fit: BoxFit.fill)),
              ),
            );
          }),
    );
  }
}
