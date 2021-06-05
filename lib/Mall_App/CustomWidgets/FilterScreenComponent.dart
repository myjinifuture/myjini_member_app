import 'dart:math';

import 'package:flutter/material.dart';
import 'package:smart_society_new/Mall_App/Common/Colors.dart';

class FilterScreenComponent extends StatefulWidget {
  var filterdata;
  FilterScreenComponent({this.filterdata});

  @override
  _FilterScreenComponentState createState() => _FilterScreenComponentState();
}

class _FilterScreenComponentState extends State<FilterScreenComponent> {
  bool c1 = false;
  bool expansion = false;
  List selecteList = [];

  _showhide() {
    setState(() {
      expansion = !expansion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 45,
          width: MediaQuery.of(context).size.width,
          child: FlatButton(
            onPressed: () {
              _showhide();
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    "${widget.filterdata["Title"]}",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: expansion == false
                        ? Icon(Icons.arrow_drop_down)
                        : Icon(Icons.arrow_drop_up)),
              ],
            ),
          ),
        ),
        Visibility(
          visible: expansion,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.filterdata["values"].length,
            itemBuilder: (BuildContext context, int vindex) {
              return Container(
                height: 48,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(
                      widget.filterdata["values"][vindex],
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                    ),
                    value: selecteList.contains(
                        "${widget.filterdata["values"][vindex]}" +
                            "#${widget.filterdata["Title"]}#"),
                    activeColor: appPrimaryMaterialColor,
                    onChanged: (bool val) {
                      setState(() {
                        String value = widget.filterdata["values"][vindex] +
                            "#${widget.filterdata["Title"]}#";
                        if (val) {
                          selecteList.add(value);
                        } else {
                          selecteList.remove(value);
                        }
                      });
                    }, //  <-- leading Checkbox
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
