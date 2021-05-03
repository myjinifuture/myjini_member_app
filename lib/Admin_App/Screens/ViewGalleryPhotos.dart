import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:smart_society_new/Member_App/common/constant.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as cnst;
import 'dart:io';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ViewGalleryPhotos extends StatefulWidget {
  var galleryData;
  Function onDelete;

  ViewGalleryPhotos({this.galleryData,this.onDelete});

  @override
  _ViewGalleryPhotosState createState() => _ViewGalleryPhotosState();
}

class _ViewGalleryPhotosState extends State<ViewGalleryPhotos> {
  bool isLoading = false;
  String galleryId;
  List images;

  @override
  void initState() {
    galleryId = widget.galleryData["_id"];
    images=[];
  }

  deleteGallery() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        var data = {
          "images": images,
          "galleryId": galleryId,
        };
        Services.responseHandler(
                apiName: "admin/deleteGalleryImage", body: data)
            .then((data) async {
          print("gallery response");
          print(data);
          if (data.IsSuccess == true && data.Data.toString() == '1') {
            Fluttertoast.showToast(
                msg: "Photo Deleted Successfully !!!",
                backgroundColor: Colors.green,
                gravity: ToastGravity.TOP);
            Navigator.pop(context);
            widget.onDelete();
            setState(() {
              isLoading = false;
            });
          } else {
            setState(() {
              isLoading = false;
            });
          }
        }, onError: (e) {
          showMsg("Something Went Wrong Please Try Again");
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

  void _showConfirmDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("MYJINI"),
          content: new Text("Are You Sure You Want To Delete this Photo?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("No",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Yes",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600)),
              onPressed: () {
                Navigator.of(context).pop();
                deleteGallery();
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    print("widget.galleryData");
    print(widget.galleryData);
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.galleryData["title"].toString()}'),
      ),
      body: Swiper(
        itemBuilder: (BuildContext, int index) {
          return Stack(
            children: [
              Center(
                child: FadeInImage.assetNetwork(
                  placeholder: "images/placeholder.png",
                  image: widget.galleryData["image"].length == 0
                      ? ""
                      : Image_Url + '${widget.galleryData["image"][index]}',
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: cnst.appPrimaryMaterialColor,
                    ),
                    onPressed: () {
                      print(widget.galleryData["image"][index]);
                       setState(() {
                         images.add(widget.galleryData["image"][index]);
                         _showConfirmDialog();
                       });
                    },
                  ),
                ],
              )
            ],
          );
        },
        itemCount: widget.galleryData["image"].length,
        pagination: new SwiperPagination(
            builder: DotSwiperPaginationBuilder(
          color: Colors.grey[400],
        )),
//                      control: new SwiperControl(size: 17),
      ),
    );
  }
}
