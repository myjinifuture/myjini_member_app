import 'package:flutter/material.dart';
import 'package:smart_society_new/Member_App/Mall/Common/DBHelper.dart';
import 'package:smart_society_new/Member_App/Mall/Common/MallClassList.dart';
import 'package:smart_society_new/Member_App/Mall/Components/offerTagClipper.dart';
import 'package:smart_society_new/Member_App/Mall/Common/ExtensionMethods.dart';
import 'package:smart_society_new/Member_App/Mall/Screens/ProductDetail.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as cnst;

class ProductComponent extends StatefulWidget {
  @override
  _ProductComponentState createState() => _ProductComponentState();
}

class _ProductComponentState extends State<ProductComponent> {
  DBHelper dbHelper;
  Future<List<AddToCartClass>> cart;

  @override
  void initState() {
    dbHelper = DBHelper();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetail(),
          ),
        );
      },
      child: Card(
        child: Container(
          width: 165,
          padding: EdgeInsets.only(top: 6, left: 5, right: 5, bottom: 7),
          child: Stack(
            alignment: Alignment.topRight,
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Image.asset(
                    "lib/Mall/Images/daawat.png",
                    width: 130,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Daawat Biryani Basmati Rice Long",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13),
                  ),
                  Text(
                    "${cnst.Inr_Rupee}120/-",
                    style: TextStyle(
                        color: Colors.green[700], fontWeight: FontWeight.w600),
                  ).alignAtStart(),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 35,
                    margin:
                        EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 6),
                    child: FlatButton(
                        child: Text(
                          "Add To Cart",
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                        color: cnst.appPrimaryMaterialColor,
                        onPressed: () {
                          dbHelper.add(AddToCartClass(
                              "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}"));
                        }),
                  )
                ],
              ),
              Positioned(
                top: -15,
                left: -15,
                child: Container(
                  width: 50,
                  height: 50,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 6, top: 6),
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.all(
                        Radius.circular(50),
                      )),
                  child: Text(
                    "New",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ).alignAtStart(),
              ),
              ClipPath(
                clipper: offerTagClipper(),
                child: Container(
                  color: Colors.green,
                  padding:
                      EdgeInsets.only(top: 3, bottom: 15, left: 3, right: 3),
                  child: Text(
                    "5%\nOff",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
