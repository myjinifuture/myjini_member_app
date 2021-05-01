import 'package:flutter/material.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as cnst;

class AdvertisementComponent extends StatefulWidget {
  var AdList;
  AdvertisementComponent(this.AdList);

  @override
  _AdvertisementComponentState createState() => _AdvertisementComponentState();
}

class _AdvertisementComponentState extends State<AdvertisementComponent> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      const EdgeInsets.only(left: 3.0, right: 3.0, top: 5.0, bottom: 5.0),
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            widget.AdList["Image"] != "" && widget.AdList["Image"] != null
                ? FadeInImage.assetNetwork(
                placeholder: "",
                width: MediaQuery.of(context).size.width,
                height: 150,
                fit: BoxFit.fill,
                image: "${cnst.Image_Url1}" + widget.AdList["Image"])
                : Image.asset(
              "images/Ad1.jpg",
              width: MediaQuery.of(context).size.width,
              height: 120,
              fit: BoxFit.fill,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "${widget.AdList["Title"]}",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "${widget.AdList["Description"]}",
                style: TextStyle(fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
