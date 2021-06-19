import 'dart:io';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart';
import 'package:smart_society_new/Member_App/screens/AdDetailPage.dart';

import 'package:flutter/material.dart';

class AdvertisementScreen extends StatefulWidget {
  @override
  _AdvertisementScreenState createState() => _AdvertisementScreenState();
}

class _AdvertisementScreenState extends State<AdvertisementScreen> {
  bool isLoading = false;
  List _advertisementData = [];

  @override
  void initState() {
    getAdvertisementData();
  }

  getAdvertisementData() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var data = {
          // "societyId": SocietyId,
        };

        setState(() {
          isLoading = true;
        });
        Services.responseHandler(apiName: "member/getAdvertisement", body: data)
            .then((data) async {
          print("data");
          print(data.Data);
          if (data.Data != null && data.Data.length > 0) {
            setState(() {
              _advertisementData = data.Data;
              isLoading = false;
            });
            print("_advertisementData");
            print(_advertisementData);
          } else {
            setState(() {
              isLoading = false;
              // _advertisementData = data.Data;
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
                Navigator.of(context).pop();
                ;
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print("_advertisementData");
    print(_advertisementData);
    return Scaffold(
      appBar: AppBar(
        title: Text('Advertisements'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: _advertisementData.length,
              itemBuilder: (BuildContext context, int index) {
                print(Image_Url + _advertisementData[index]["Image"][0]);
                return GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdDetailPage(data: _advertisementData[index],),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top:5.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.218,
                      decoration:  BoxDecoration(
                          image: new DecorationImage(
                              image: NetworkImage(
                                Image_Url + _advertisementData[index]["Image"][0],
                              ),
                              fit: BoxFit.fill)),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
