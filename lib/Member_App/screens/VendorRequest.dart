import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import '../common/Services1.dart';
import '../common/constant.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;
import 'package:smart_society_new/Member_App/common/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Admin_App/Common/Constants.dart';

class VendorRequest extends StatefulWidget {

  @override
  _VendorRequestState createState() => _VendorRequestState();
}

class _VendorRequestState extends State<VendorRequest> {

  TextEditingController _txtdescription = TextEditingController();
  DateTime selectedDate = DateTime.now();
  int _index = 0;
  bool isLoading = false;

  showMsg(String msg, {String title = 'DashBord'}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(title),
          content: new Text(msg),
          actions: <Widget>[
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Vendor Request',
          style: TextStyle(fontSize: 18),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CalendarTimeline(
                selectableDayPredicate: (date) => date.day != 7,
                firstDate: DateTime.now(),
                initialDate: selectedDate,
                lastDate: DateTime.now().add(Duration(days: 365)),
                onDateSelected: (date) {
                  selectedDate = date;
                  print(selectedDate);
                },
                monthColor: Colors.transparent,
                dayColor: Colors.deepPurple,
                dotsColor: Colors.transparent,
                activeDayColor: Colors.purple,
                activeBackgroundDayColor: Colors.grey[200],
               //  selectableDayPredicate: (date) => date.weekday != 7,
                locale: 'en',
              ),
              Padding(padding: EdgeInsets.only(top:15.0)),
              Container(
                  height: 120,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.deepPurple[200],
                  ),
                  child: CupertinoPicker(
                    itemExtent: 50,
                    onSelectedItemChanged: (int index) {
                      setState(() {
                        _index = index;
                      });
                    },
                    children:[
                      textTime("7:00 am"),
                      textTime("7:30 am"),
                      textTime("8:00 am"),
                      textTime("8:30 am"),
                      textTime("9:00 am"),
                      textTime("9:30 am"),
                      textTime("10:00 am"),
                      textTime("10:30 am"),
                      textTime("11:00 am"),
                      textTime("11:30 am"),
                      textTime("12:00 pm"),
                      textTime("12:30 pm"),
                      textTime("1:00 pm"),
                      textTime("1:30 pm"),

                      Text(
                        "11:00 am",
                        style: TextStyle(fontSize: 24,
                            color: _index == 4 ? Colors.black : Colors.black),
                      ),
                    ],
                  )),
              Padding(padding: EdgeInsets.only(top:12.0)),
              TextFormField(
                  controller: _txtdescription,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: "Description",
                    hintText: "Enter Description",
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  )),
              Padding(padding: EdgeInsets.only(top:30.0)),
              Row(
                children: [
                  Expanded(
                    child: RaisedButton(
                      onPressed: () {
                        setState(() {
                         // vendorRequest(_txtdescription.text, selectedDate);
                        });
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      color: Colors.deepPurple,
                      child: Text(
                        "Submit",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
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

  textTime(text){
    return Text(text,style : TextStyle(fontSize: 24,
        color:Colors.black ));
  }
}
