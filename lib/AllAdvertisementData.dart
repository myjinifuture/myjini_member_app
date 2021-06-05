import 'package:flutter/material.dart';

import 'Member_App/common/constant.dart';
import 'Member_App/screens/AdDetailPage.dart';

class AllAdvertisementData extends StatefulWidget {
  List advertisementData = [];

  AllAdvertisementData({this.advertisementData});

  @override
  _AllAdvertisementDataState createState() => _AllAdvertisementDataState();
}

class _AllAdvertisementDataState extends State<AllAdvertisementData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Advertisements",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
      body: ListView.builder(
          itemCount: widget.advertisementData.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdDetailPage(
                      data: widget.advertisementData[index],
                    ),
                  ),
                );
              },
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Image.network(
                      Image_Url + widget.advertisementData[index]["Image"],
                      fit: BoxFit.fill)),
            );
          }),
    );
  }
}
