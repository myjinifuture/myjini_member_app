import 'package:flutter/material.dart';

class MyPointsComponent extends StatefulWidget {
  var pointsdata;
  MyPointsComponent({this.pointsdata});

  @override
  _MyPointsComponentState createState() => _MyPointsComponentState();
}

class _MyPointsComponentState extends State<MyPointsComponent> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0, top: 8),
                    child: Text(
                      "${widget.pointsdata["PointsDate"]}",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 15),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 17.0,
                          backgroundColor: Colors.grey[200],
                          foregroundColor: Colors.white,
                          child: Image.asset("assets/coin.png", width: 17),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(
                            "${widget.pointsdata["PontsDescription"]}",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Text(
                      "${widget.pointsdata["PointsType"]}",
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0, top: 6),
                    child: Text(
                      "${widget.pointsdata["Points"]}",
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
