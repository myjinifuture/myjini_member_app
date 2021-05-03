import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:smart_society_new/Member_App/common/constant.dart';

class AllImagesInGallery extends StatefulWidget {
  var data;
  AllImagesInGallery({this.data});
  @override
  _AllImagesInGalleryState createState() => _AllImagesInGalleryState();
}

class _AllImagesInGalleryState extends State<AllImagesInGallery> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Swiper(
      itemBuilder: (BuildContext, int index) {
      return  Center(
        child: FadeInImage.assetNetwork(
          placeholder: "images/placeholder.png",
          image: widget.data["image"].length == 0
              ? ""
              : Image_Url +
              '${widget.data["image"][index]}',
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        ),
      );
      },
      itemCount: widget.data["image"].length,
      pagination: new SwiperPagination(
      builder: DotSwiperPaginationBuilder(
      color: Colors.grey[400],
      )),
//                      control: new SwiperControl(size: 17),
      ),
    );

  }
}
