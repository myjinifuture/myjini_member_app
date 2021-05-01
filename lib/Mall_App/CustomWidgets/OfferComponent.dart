import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_society_new/Mall_App/Common/Constant.dart';
import 'package:smart_society_new/Mall_App/Screens/ProductListing.dart';
import 'package:smart_society_new/Mall_App/transitions/slide_route.dart';

class OfferComponent extends StatefulWidget {
  var Offerdata;
  OfferComponent({this.Offerdata});
  @override
  _OfferComponentState createState() => _OfferComponentState();
}

class _OfferComponentState extends State<OfferComponent> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            SlideLeftRoute(
                page: ProductListing(
              SubCategoryId: widget.Offerdata["SubcategoryId"],
            )));
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 7.0, right: 7),
        child: Container(
          color: Colors.grey[200],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(IMG_URL + widget.Offerdata["OfferImage"],
                  height: 140,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.contain),
              Padding(
                padding: const EdgeInsets.only(left: 5.0, top: 3),
                child: Text(
                  "${widget.Offerdata["OfferName"]}",
                  style: TextStyle(fontSize: 15),
                ),
              ),
              Text("${widget.Offerdata["SubcategoryDesc"]}"),
            ],
          ),
        ),
      ),
    );
  }
}
