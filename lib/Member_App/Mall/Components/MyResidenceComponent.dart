import 'package:flutter/material.dart';
import 'package:smart_society_new/Mall_App/Common/Colors.dart';

class MyResidenceComponent extends StatefulWidget {
  var resData;
  int index;
  MyResidenceComponent({this.resData,this.index});
  @override
  _MyResidenceComponentState createState() => _MyResidenceComponentState();
}

class _MyResidenceComponentState extends State<MyResidenceComponent> {
  @override
  Widget build(BuildContext context) {
    print("widget.resData");
    print(widget.resData);
    return Padding(
      padding: const EdgeInsets.only(right: 8, left: 8),
      child: Container(
        decoration: BoxDecoration(
          color: appPrimaryMaterialColor[50],
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.home_work,
                size: 40,
                color: appPrimaryMaterialColor,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   "${widget.resData["Property"][0]['SocietyData'][0]['Name']}",
                    //   style: TextStyle(fontSize: 18, color: Colors.black),
                    // ),
                    Row(
                      children: [
                        Text(
                          "${widget.resData["Property"][0]["WingData"][0]['wingName']}-${widget.resData["Property"][0]['flatNo']}",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 13),
                        ),
                        // widget.index==0?Padding(
                        //   padding: const EdgeInsets.only(left: 10.0),
                        //   child: Container(
                        //     decoration: BoxDecoration(
                        //       color: appPrimaryMaterialColor[600],
                        //       borderRadius: BorderRadius.circular(5),
                        //     ),
                        //     child: Padding(
                        //       padding: const EdgeInsets.all(5.0),
                        //       child: Text(
                        //         "Primary",
                        //         style: TextStyle(
                        //             color: Colors.white, fontSize: 10),
                        //       ),
                        //     ),
                        //   ),
                        // ):Container()
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}