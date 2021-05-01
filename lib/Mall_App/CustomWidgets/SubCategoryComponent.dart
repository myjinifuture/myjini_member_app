import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:smart_society_new/Mall_App/Common/Constant.dart';
import 'package:smart_society_new/Mall_App/Screens/ProductListing.dart';
import 'package:smart_society_new/Mall_App/transitions/slide_route.dart';

class SubCategoryComponent extends StatefulWidget {
  var category;
  SubCategoryComponent(this.category);
  @override
  _SubCategoryComponentState createState() => _SubCategoryComponentState();
}

class _SubCategoryComponentState extends State<SubCategoryComponent> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    log(widget.category.toString());
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            SlideLeftRoute(
                page: ProductListing(
                    SubCategoryId: '${widget.category["SubcategoryId"]}')));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white30,
          border: Border.all(
            color: Colors.black26,
            width: 0.2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: widget.category["SubcategoryImage"] == ""
                  ? Image.network(
                      "${IMG_URL + widget.category["SubcategoryImage"]}",
                      width: 70,
                      height: 70,
                    )
                  : Image.asset(
                      'assets/no-image.png',
                      width: 110,
                      height: 110,
                    ),
            ),
            //  packageInfo[0]["ProductdetailImages"] != ""
            //                         ? Image.network(
            //                             "${IMG_URL + packageInfo[0]["ProductdetailImages"][0]}",
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "${widget.category["SubcategoryName"]}",
                maxLines: 1,
                softWrap: true,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
