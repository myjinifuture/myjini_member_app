import 'package:flutter/material.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as cnst;
import 'package:url_launcher/url_launcher.dart';

class MyServiceRequestComponent extends StatefulWidget {
  var NewList;

  MyServiceRequestComponent(this.NewList);

  @override
  _MyServiceRequestComponentState createState() =>
      _MyServiceRequestComponentState();
}

class _MyServiceRequestComponentState extends State<MyServiceRequestComponent> {
  String setDate(String date) {
    String final_date = "";
    var tempDate;
    if (date != "" || date != null) {
      tempDate = date.toString().split("-");
      if (tempDate[2].toString().length == 1) {
        tempDate[2] = "0" + tempDate[2].toString();
      }
      if (tempDate[1].toString().length == 1) {
        tempDate[1] = "0" + tempDate[1].toString();
      }
      final_date = "${tempDate[2].toString().substring(0, 2)}-"
              "${tempDate[1].toString().substring(0, 2)}-${tempDate[0].toString()}"
          .toString();
    }
    return final_date;
  }

  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Card(
            elevation: 3.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(0.0))),
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Center(
                          child: Text(
                            "${widget.NewList["VendorName"]}",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          launch("tel:${widget.NewList["VendorMobile"]}");
                        },
                        child: Image.asset(
                          "images/phone1.png",
                          height: 35,
                          width: 35,
                        ),
                      )
                    ],
                  ),
                  Divider(
                    thickness: 1,
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        "Service",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "${widget.NewList["CategoryName"]}",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                  Divider(),
                  Row(
                    children: <Widget>[
                      Text(
                        "ServicePackage",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "${widget.NewList["ServicePackageName"]}",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                  Divider(),
                  Row(
                    children: <Widget>[
                      Text(
                        "Service",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        widget.NewList["GetServicePackagePriceName"] == null ||
                                widget.NewList["GetServicePackagePriceName"] ==
                                    ""
                            ? "${widget.NewList["GetServicePackagePriceName"]}"
                            : "",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                  Divider(),
                  Row(
                    children: <Widget>[
                      Text(
                        "Amount",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        cnst.Inr_Rupee + " ${widget.NewList["TotalAmount"]}",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                  Divider(),
                  Row(
                    children: <Widget>[
                      Text(
                        "Date",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "${setDate(widget.NewList["Date"])}",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                  Divider(),
                  Row(
                    children: <Widget>[
                      Text(
                        "Status",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "${widget.NewList["Status"]}",
                        style: TextStyle(
                            color: widget.NewList["Status"] == "Completed"
                                ? Colors.green
                                : widget.NewList["Status"] == "Pending"
                                    ? Colors.red
                                    : widget.NewList["Status"] == "Cancelled"
                                        ? Colors.red
                                        : Colors.grey),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
