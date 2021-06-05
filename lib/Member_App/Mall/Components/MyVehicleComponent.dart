import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smart_society_new/Mall_App/Common/Colors.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';

class MyVehicleComponent extends StatefulWidget {
  var vehicleData;
  Function onDelete;
  MyVehicleComponent({this.vehicleData, this.onDelete});
  @override
  _MyVehicleComponentState createState() => _MyVehicleComponentState();
}

class _MyVehicleComponentState extends State<MyVehicleComponent> {
  @override
  Widget build(BuildContext context) {
    print(widget.vehicleData["vehicleNo"]);
    return GestureDetector(
      onTap: () {
        _settingModalBottomSheet();
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 8, left: 8),
        child: Container(
          decoration: BoxDecoration(
            color: appPrimaryMaterialColor[50],
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                widget.vehicleData["vehicleType"] == "Car"
                    ? Image.asset(
                        "images/automobile.png",
                        width: 40,
                      )
                    : Image.asset("images/bike.png", width: 40),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.vehicleData["vehicleNo"],
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _settingModalBottomSheet() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.0),
        ),
        backgroundColor: Colors.white,
        context: context,
        builder: (builder) {
          return new Container(
              height: 190.0,
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Text(
                        "Vehicle",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w600
                            //fontWeight: FontWeight.bold
                            ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20.0, right: 15, left: 25, bottom: 15),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: widget.vehicleData["vehicleType"] == "Car"
                                ? AssetImage(
                                    "images/automobile.png",
                                  )
                                : AssetImage(
                                    "images/bike.png",
                                  ),
                            backgroundColor: Colors.grey[200],
                            radius: 45,
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${widget.vehicleData["vehicleType"]}" == "Car"
                                        ? "Four Wheeler"
                                        : "Two Wheeler",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    widget.vehicleData["vehicleNo"],
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: appPrimaryMaterialColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              _showConfirmDialog(
                                  widget.vehicleData["_id"].toString());
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Icon(Icons.delete),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ));
        });
  }

  void _showConfirmDialog(String Id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDelete(
          deleteId: Id,
          onDelete: () {
            widget.onDelete();
          },
        );
      },
    );
  }
}

class AlertDelete extends StatefulWidget {
  var deleteId;
  Function onDelete;
  AlertDelete({this.deleteId, this.onDelete});

  @override
  _AlertDeleteState createState() => _AlertDeleteState();
}

class _AlertDeleteState extends State<AlertDelete> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: new Text("MYJINI"),
      content: new Text("Are You Sure You Want To Delete this Vehicle ?"),
      actions: <Widget>[
        new FlatButton(
          child: new Text("No",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
          onPressed: () {
            Navigator.of(context).pop();;
          },
        ),
        new FlatButton(
          child: new Text("Yes",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
          onPressed: () {
            widget.onDelete();
            Navigator.of(context).pop();;
          },
        ),
      ],
    );
  }

  showHHMsg(String title, String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(title),
          content: new Text(msg),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();;
              },
            ),
          ],
        );
      },
    );
  }
}
