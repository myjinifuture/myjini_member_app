import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
class AddCab extends StatefulWidget {

  @override
  _AddCabState createState() => _AddCabState();
}

class _AddCabState extends State<AddCab> {

  TextEditingController _txtDelivervPername = TextEditingController();
  TextEditingController _txtMobileno = TextEditingController();
  bool isbottomBar = false;
  int _value = 1;
  DateTime _datetime1;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          title: Text(
            "Cab",
            style: TextStyle(fontSize: 18, fontFamily: "OpenSans"),
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple, Colors.deepPurple],
                stops: [0.1, 7.0],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 0.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(25.0),
                                  topLeft: Radius.circular(25.0)),
                            ),
                            child: Row(
                              children: [
                                Padding(padding: EdgeInsets.only(left: 20.0)),
                                Text(
                                  "Add Cab",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "OpenSans"),
                                ),
                                Padding(padding: EdgeInsets.only(left: 220.0)),
                                isbottomBar
                                    ? IconButton(
                                    icon: Icon(
                                      Icons.arrow_back_ios,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        isbottomBar = !isbottomBar;
                                      });
                                    })
                                    : IconButton(
                                    icon: Icon(
                                      Icons.keyboard_arrow_down,
                                      size: 30,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        isbottomBar = !isbottomBar;
                                      });
                                    })
                              ],
                            ),
                          ),
                          bottomBar(),
                        ],
                      ),
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
  bottomBar() {
    return Visibility(
      visible: isbottomBar,
      child: Container(
        height: MediaQuery.of(context).size.height / 1.9,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Cab Company Name",
                  style: TextStyle(fontFamily: "OpenSans"),
                ),
                Padding(padding: EdgeInsets.only(top: 6.0)),
                Container(
                  height: MediaQuery.of(context).size.height / 18,
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButton(
                          underline: SizedBox(),
                          icon: Icon(Icons.arrow_right),
                          isExpanded: true,
                          value: _value,
                          items: [
                            DropdownMenuItem(
                              child: Text(
                                "Quick Cab",
                                style: TextStyle(
                                    fontFamily: "OpenSans", fontSize: 12),
                              ),
                              value: 1,
                            ),
                            DropdownMenuItem(
                              child: Text(
                                "Fareies",
                                style: TextStyle(
                                    fontFamily: "OpenSans", fontSize: 12),
                              ),
                              value: 2,
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _value = value;
                            });
                          }),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 6.0)),
                Row(
                  children: [
                    Text(
                      "Delivery Person Name",
                      style: TextStyle(fontFamily: "OpenSans"),
                    ),
                    Text(
                      "(optional)",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                          fontFamily: "OpenSans"),
                    )
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 6.0)),
                Container(
                  height: MediaQuery.of(context).size.height / 18,
                  child: TextFormField(
                    controller: _txtDelivervPername,
                    decoration: InputDecoration(
                      labelText: "Deliver Person Name",
                      isDense: true,
                      hintText: "Enter Deliver Person Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 6.0)),
                Row(
                  children: [
                    Text(
                      "Mobile Number",
                      style: TextStyle(fontFamily: "OpenSans"),
                    ),
                    Text(
                      "(optional)",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                          fontFamily: "OpenSans"),
                    )
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 6.0)),
                Container(
                  height: MediaQuery.of(context).size.height / 18,
                  child: TextFormField(
                    controller: _txtMobileno,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10),
                    ],
                    decoration: InputDecoration(
                      labelText: "Mobile Number",
                      isDense: true,
                      hintText: "Enter Mobile Number",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 6.0)),
                Text(
                  "Estimated Arival Date",
                  style: TextStyle(fontFamily: "OpenSans"),
                ),
                Padding(padding: EdgeInsets.only(top: 6.0)),
                Container(
                    height: MediaQuery.of(context).size.height / 18,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(_datetime1 == null
                              ? 'No date Select!'
                              : '${DateFormat('dd MMMM yyyy').format(_datetime1)}'),
                          Padding(padding: EdgeInsets.only(left: 195)),
                          InkWell(
                            child: Icon(
                              Icons.arrow_right,
                              color: Colors.grey,
                            ),
                            onTap: () {
                              showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2001),
                                  lastDate: DateTime(2022))
                                  .then((date) {
                                setState(() {
                                  _datetime1 = date;
                                });
                              });
                            },
                          )
                        ],
                      ),
                    )),
                Padding(padding: EdgeInsets.only(top: 10.0)),
                Center(
                  child: RaisedButton(
                    onPressed: () {},
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    color: Colors.deepPurple,
                    child: Padding(
                      padding: EdgeInsets.only(left: 100.0, right: 100.0),
                      child: Text(
                        "Save",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "OpenSans",
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
