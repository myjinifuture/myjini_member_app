import 'dart:io';
import 'package:flutter/material.dart';
import 'package:smart_society_new/Member_App/Services/ServiceList.dart';
import 'package:smart_society_new/Member_App/common/constant.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart';

class ServiceDetail extends StatefulWidget {
  var ServiceDetailData;

  ServiceDetail(this.ServiceDetailData);

  @override
  _ServiceDetailState createState() => _ServiceDetailState();
}

class _ServiceDetailState extends State<ServiceDetail> {
  @override
  void initState() {
    //print("HelloWorlddd=>> " + widget.ServiceDetailData.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                //Navigator.pushReplacementNamed(context, "/Vendors");
              }),
          centerTitle: true,
          title: Text(
            'Title',
            style: TextStyle(fontSize: 18),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(10),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
      color: Colors.grey[100],
      child: Column(
            children: <Widget>[
              /*Stack(
                children: <Widget>[
                  *//* Container(
                    height: 150,
                    child: FadeInImage.assetNetwork(
                      placeholder: "images/placeholder.png",
                      image: Image_Url + '${widget.ServiceDetailData["Image"]}',
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Opacity(
                    opacity: 0.6,
                    child: Container(
                      height: 150,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.black,
                    ),
                  ),*//*
                  Padding(
                    padding: const EdgeInsets.only(top: 100.0, left: 10),
                    child: Text(
                      'Title',
                        //'${widget.ServiceDetailData["Title"]}',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontSize: 18)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25.0, left: 4.0),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),*/
              Container(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  child: Column(
                    children: <Widget>[
                      /*widget.ServiceDetailData["ServicePackagePrice"].length > 1
                          ? */ExpansionTile(
                              //onExpansionChanged: ,
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                          'Rate',
                                      //'${widget.ServiceDetailData["ServicePackagePrice"][0]["Price"]}',
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black)),
                               /*   Text(
                                      "₹" +
                                          'Price',
                                      //'${widget.ServiceDetailData["ServicePackagePrice"][0]["Price"]}',
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black))*/
                                ],
                              ),
                              children: <Widget>[
                               /* Column(
                                  children: _PriceListData(widget
                                      .ServiceDetailData["ServicePackagePrice"]),
                                )*/
                               Column(
                                 children: <Widget>[
                                   Padding(
                                     padding: const EdgeInsets.only(left:10.0,right: 10.0,bottom: 8.0),
                                     child: Row(
                                       children: <Widget>[
                                         Text(
                                                 'Price',
                                             //'${widget.ServiceDetailData["ServicePackagePrice"][0]["Price"]}',
                                             style: TextStyle(
                                                 fontSize: 17,
                                                 fontWeight: FontWeight.w400,
                                                 color: Colors.black)),
                                         Text( "₹" +
                                             ' 500',
                                             //'${widget.ServiceDetailData["ServicePackagePrice"][0]["Price"]}',
                                             style: TextStyle(
                                                 fontSize: 17,
                                                 fontWeight: FontWeight.w600,
                                                 color: Colors.black)),

                                       ],
                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                     ),
                                   ),
                                 ],
                               )
                              ],
                            )
                         /* : Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 15.0, top: 10.0, bottom: 6.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text("Starting From",
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.grey[600])),
                                    Text(
                                        "₹" +
                                            '${widget.ServiceDetailData["ServicePackagePrice"][0]["Price"]}',
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black))
                                  ],
                                ),
                              ),
                            )*/
                    ],
                  ),
                ),
              ),
              Card(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6.0),
                        child: Text("Description",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.black)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6.0,top: 6.0),
                        child: Text("There are dozens of actively maintained wiki engines. They vary in the platforms they run on, the programming language they were developed in, whether they are open-source or proprietary, their support for natural language characters and conventions, and their assumptions about technical versus social control of editing.",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.black)),
                      ),
                      /*Text(

                         widget.ServiceDetailData["Description"]
                      ),*/
                    ],
                  ),
                ),
              )
            ],
      ),
    ),
          ),
        ));
  }
}

_PriceListData(var list) {
  List<Widget> Pricelist = [];
  for (int i = 0; i < list.length; i++) {
    Pricelist.add(
      Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text('${list[i]["Title"]}',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black)),
                  ),
                  Text('${list[i]["Price"]}' + "0",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black))
                ],
              ),
            ),
          ),
        ],
      ),
    );

    //print('${list[i]["Title"]}');
  }
  ;
  return Pricelist;
}
