import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;
import 'package:smart_society_new/Member_App/common/constant.dart';

class EventPhotos extends StatefulWidget {
  var EventData;

  EventPhotos(this.EventData);

  @override
  _EventPhotosState createState() => _EventPhotosState();
}

class _EventPhotosState extends State<EventPhotos> {
  List ImageList = new List();
  bool isLoading = false;
  String SocietyId;

  @override
  void initState() {
    _getLocaldata();
  }

  _getLocaldata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SocietyId = prefs.getString(constant.Session.SocietyId);
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
                Navigator.of(context).pop();;
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '${widget.EventData["Title"]}',
          style: TextStyle(fontSize: 18),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        ),
      ),
      body: isLoading
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : ImageList.length > 0
              ? Container(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                    child: Swiper(
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: FadeInImage.assetNetwork(
                            placeholder: "images/placeholder.png",
                            image: Image_Url + '${ImageList[index]["Image"]}',
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                      itemCount: ImageList.length,
                      loop: false,
                      pagination: SwiperPagination(builder:
                          SwiperCustomPagination(builder: (BuildContext context,
                              SwiperPluginConfig config) {
                        return Container(
                          color: Colors.black54,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "${config.activeIndex + 1} / ${config.itemCount}",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w200,
                                  color: Colors.white),
                            ),
                          ),
                        );
                      })),
                      // control: new SwiperControl(),
                    ),
                  ),
                )
              : Container(
                  child: Center(
                    child: Text("No Image Found"),
                  ),
                ),
    );
  }
}
