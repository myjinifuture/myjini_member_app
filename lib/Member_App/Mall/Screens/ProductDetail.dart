import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_society_new/Member_App/Mall/Common/ExtensionMethods.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as cnst;

class ProductDetail extends StatefulWidget {
  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product Detail"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 7, bottom: 10),
            child: Image.asset(
              "lib/Mall/Images/daawat.png",
              height: 250,
              fit: BoxFit.fitHeight,
              width: MediaQuery.of(context).size.width,
            ),
          ),
          Expanded(
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  children: <Widget>[
                    Text(
                      "Daawat Biryani Basmati Rice Long",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ).alignAtStart(),
                    Text(
                      "${cnst.Inr_Rupee}120/-",
                      style: TextStyle(
                          color: Colors.green[700],
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                    ).alignAtStart(),
                    Text(
                      "BASMATI RICE. The Signature of Authentic Biryani is the length of the rice grain. Daawat Biryani is the Worlds Longest grains which gives Finest presentation to the Biryani.",
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 6, bottom: 10),
                      child: Text(
                        "In Stock",
                        style: TextStyle(color: Colors.green, fontSize: 16),
                      ).alignAtStart(),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 3,
                      height: 36,
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.grey)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          IconButton(
                              icon: Icon(Icons.remove, color: Colors.red),
                              onPressed: () {}),
                          Expanded(
                            child: Text("1",
                                style: TextStyle(
                                    color: cnst.appPrimaryMaterialColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15)),
                          ),
                          IconButton(
                              icon: Icon(Icons.add, color: Colors.red),
                              onPressed: () {}),
                        ],
                      ),
                    ).alignAtStart(),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      child: RaisedButton(
                          child: Text(
                            "Add To Cart",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: cnst.appPrimaryMaterialColor,
                          onPressed: () {}),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
