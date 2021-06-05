import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:smart_society_new/Admin_App/Common/Constants.dart' as cnst;

class EventDetailAdmin extends StatefulWidget {
  Map EventsData = {};
  EventDetailAdmin({this.EventsData});
  @override
  _EventDetailAdminState createState() => _EventDetailAdminState();
}

class _EventDetailAdminState extends State<EventDetailAdmin> {
  int selectedWing = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Event Detail",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              for (int i = 0; i < 3; i++) ...[
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedWing = i;
                    });
                  },
                  child: Container(
                    width: selectedWing == i ? 60 : 45,
                    height: selectedWing == i ? 60 : 45,
                    margin: EdgeInsets.only(top: 10, left: 5, right: 5),
                    decoration: BoxDecoration(
                        color: selectedWing == i
                            ? cnst.appPrimaryMaterialColor
                            : Colors.white,
                        border: Border.all(color: cnst.appPrimaryMaterialColor),
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                    alignment: Alignment.center,
                    child: Text(
                      "${i}",
                      style: TextStyle(
                          color: selectedWing == i
                              ? Colors.white
                              : cnst.appPrimaryMaterialColor,
                          fontSize: 19),
                    ),
                  ),
                ),
              ],
            ],
          ),
          SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        width: 15,
                        height: 15,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Text(
                        "(0)",
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                  Text(
                    "Closed",
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        width: 15,
                        height: 15,
                        color: Colors.lightBlueAccent,
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Text(
                        "(12)",
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  Text(
                    "Active",
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        width: 15,
                        height: 15,
                        color: Colors.green,
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Text(
                        "(68)",
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  Text(
                    "Going",
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        width: 15,
                        height: 15,
                        color: cnst.appPrimaryMaterialColor,
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Text(
                        "(43)",
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  Text(
                    "Not Going",
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          Expanded(
            child: Card(
              margin: EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 10),
              elevation: 4,
              child: StaggeredGridView.countBuilder(
                crossAxisCount: 4,
                itemCount: 20,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                          color: index % 2 == 0
                              ? Colors.green
                              : cnst.appPrimaryMaterialColor,
                          borderRadius: BorderRadius.all(Radius.circular(3))),
                      margin: EdgeInsets.all(4),
                      alignment: Alignment.center,
                      height: 45,
                      child: Text(
                        "A- ${index + 1}0",
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                  );
                },
                staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
